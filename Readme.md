# Dockerfile Contest

I started this repository after [2025 Dockerfile Contest](https://devops.vn/webinar/dockerfile-contest-2025/) - thank DevOps Vietnam and DataOnline for organizing the contest, where I did not stand a chance to win due to a lot of "**lightweight**" Dockerfiles. (_I put lightweight in **""**, as it means a different way - **no redundant code, no extra configs, almost nothing! - you have to build all binaries yourself**_)

When I joined a webinar for the closing ceremony, I once heard a question from an audience, asking: _"**Why are you using this way, instead of doing the basic way, which is by Chainguard Docker images? And are there potential security concerns when you are building the configs by yourself?**"_ 

I thought: _"**Hey, why don't you make a Dockerfile which can receive updates daily and auto-rebuild your Docker image automatically?**"_

## The folder tree

Currently this is simple:
- ```.github/``` with some Markdown files for wordings and a ```docker.yml``` file - the main CI/CD workflow
- ```2025/```
    - ```vite-react-template```: The source code folder
    - ```Dockerfile```: The main Dockerfile (I move this file from the source code folder to the desired place)
    - ```Dockerfile.linux_contest```: The Dockerfile that I submitted to the Organization Board 
    - ```Dockerfile.windows_contest```: The Dockerfile that I have to create due to a "**stupid**" folder move from a ```ext4``` filesystem to a ```ntfs``` partition.
    - ```Readme.md```: The explanation (in Vietnamese) that I submitted to the Organization Board
- ```Readme.md```: This file
- ```LICENSE```: MIT

You can explore yourself in this repository.

## How to use it

```bash
docker pull ghcr.io/anthony2708/vite-react-chainguard
```
Check the current status and different ways to download your desired images **[here](https://github.com/anthony2708/dockerfile-contest/pkgs/container/vite-react-chainguard)**.

I have built Multi-arch images for ```linux/amd64```, ```linux/arm64``` and ```others``` architectures.

## The secrets

I put the most of my knowledge here.

### Dockerfile

There are 3 steps initially done in my Dockerfile.

When I first submitted my Dockerfile, I used ```cgr.dev/chainguard``` for my **Node (Build step)** and **Nginx (Run step)**, and ```busybox``` for **wget Healthcheck (Step 2)**. It turned out that wget added **1MB** to my final submission, which is not good for a Dockerfile competition.

I decide to rewrite my Dockerfile after the exam, and I choose to **remove ```busybox```**. What I did was:

- Keep my same Build step, but **add a flag** to determine a correct owner of the folder: ```node:node``` and remove artifacts mapping, which is causing a huge of data to be added to the final source.
```Dockerfile
COPY --chown=node:node src ./src
COPY --chown=node:node public ./public
RUN pnpm run build && find dist -type f \( -name "*.map" -o -name ".*" \) -delete
```
- Use ```cgr.dev/chainguard/wolfi-base``` to zip the ```app/dist``` folder from Build step. 
- Replace **wget healthcheck** with **nginx default config check**, which is included in Chainguard Nginx base image.

```Dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD ["/usr/sbin/nginx", "-t", "-q"]
```

### CI/CD

**This is the best part of it.**

I choose to write my CI/CD pipeline, and set up the Docker image tags as ```latest```, even all best practices are pointing to using **SHA256** for base ones. Why?

Well, **Chainguard scans images everyday**. If they detect a CVE, they will attempt to fix it asap, and they only attempt to build minimal base images, which only includes **a subset of packages** serving apps themselves and **reduces the attack surface** of them. You will have a no-shell, no-APK Nginx image from Chainguard to use, which is good in the final long run. 

Also, you are now trying to push an image to **Github Container Registry (GHCR)**, which is linked to your Github repo. So **why don't you build a CI/CD in which each push means a rebuild of a safer package?**

Another thing to consider about CI/CD is - I choose to do a Pull-and-Push with Buildkit enabled for better caching, yet having same functionalities of getting the latest, most secure image on time:

```yml
    ...
      - name: Build and push images to ghcr
        id: push
        uses: docker/build-push-action@v6
        with:
          context: 2025/vite-react-template
          file: 2025/Dockerfile
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          push: true
          pull: true
          sbom: true
          provenance: mode=max
          cache-from: type=gha
          cache-to: type=gha, mode=max
          platforms: linux/amd64, linux/arm64
    ...
```

Also, I have tried to grab my published image after a success build and chosen an action called ```anchore/scan-action``` - That is **Grype** actually (aha!) to run in another job for scanning for vulnarabilities in a same workflow, and also upload the scan report results to Github too!

```yml
    ...
      - name: Scan with Grype
        id: scan
        uses: anchore/scan-action@v6
        with:
          image: ${{ steps.ref.outputs.IMAGE_REFERENCE }}
          severity-cutoff: high
          output-file: ${{ runner.temp }}/grype.sarif

      - name: Upload results to github
        uses: github/codeql-action/upload-sarif@v4
        if: ${{ !cancelled() }}
        with:
          sarif_file: ${{ runner.temp }}/grype.sarif
    ...
```

One advancement of my CI/CD pipeline is, I put it in ```schedule``` mode, meaning that it will run **on a cron job** (which is far more better than ever, because my image can be **rebuilt daily** to patch all security loopholes that might exploit out there). 

Currently, it is a **daily check**, and can be done **manually** by me (if there are errors occured). I am considering whether my pipeline needs a **per-push deployment** or not.

## The results
Well, I might say it is not getting the smallest size at all, but it is actually smaller than what I expected from a Base image (oops, **I must compare it to Nginx and not static one haha**, but **17.6MB** is better than 50+MB :>):

![size](/img/size.png)

But looking closely at the zipped source code, this makes me happy (**672kB for zipped files, 127B for Nginx config file**):

![inspect](/img/inspect.png)

And if you want to see what happens to my Github Actions pipeline, go to **[this place](https://github.com/anthony2708/dockerfile-contest/actions)** for more information.

## Base images to refer
This is also a place where you can track all CVEs that Chainguard has been detected in each of the base images that I use:

- [Chainguard Node](https://images.chainguard.dev/directory/image/node/versions)
- [Chainguard Nginx](https://images.chainguard.dev/directory/image/nginx/versions)
- [Chainguard Wolfi-base](https://images.chainguard.dev/directory/image/wolfi-base/versions)
- [Busybox](https://hub.docker.com/_/busybox) - This one, not relevant, alternatively plays a role of compare and contrast here.

## TODO & Recommendations
I would say this: 

_You actually don't need to build this Vite/React app on Docker, unless you want to **host it on Kubernetes**. Even with **React, Angular, Vue** or some simple **HTML/CSS/JS files** on Github repository, you are okay to use **Github Pages** instead (if you are choosing **public visibility** for your codebase). If you don't believe in Github Pages, check my official repo **[here](https://github.com/anthony2708/anthony2708)**._

_Choose Docker, if that is a **private repo** (and **please don't use the CI/CD workflow - it may cost money per-minute and per-CPU**). Choose Docker, if that is **not a JS-related project** (or maybe not a **SPA project**). Java, Python (**some of them can be using Github Pages also**), C++, Golang, Rust - all of them needs Docker._

My to-do list? Well, I will try to build another Nginx base image based on Chainguard and publish here. I don't want to keep it for myself - providing the safest and easiest way to build the smallest Docker images is my concern after Dockerfile Contest, not just for the smallest images that I have to "**get my hands dirty**" and monitor the safety of all dependencies myself.

## Other things to show
Please check the Contributing file **[here](./.github/CONTRIBUTING.md)**, your CoC - Code of Conduct **[here](./.github/CODE_OF_CONDUCT.md)**, and all of my templates to use for your Issues report **[here](./.github/ISSUE_TEMPLATE/)**.

## [LICENSE](./LICENSE)
MIT - 2025
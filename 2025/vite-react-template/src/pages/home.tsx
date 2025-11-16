export default function Home() {
  const css = `
  :root {
    --bg-top: #0048D8;
    --bg-mid: #002C8B;
    --bg-bot: #001B4F;
    --btn-top: #1E80FF;
    --btn-bot: #0062FF;
    --btn-text: #FFFFFF;
    --text: #FFFFFF;
    --text-sub: #DCE6FF;
    --shell: #000A14;
    --radius: 20px;
  }

  * { box-sizing: border-box; }
  html, body { height: 100%; margin: 0; }

  .page {
    min-height: 100vh;
    display: flex; flex-direction: column;
    background: linear-gradient(180deg, var(--bg-top) 0%, var(--bg-mid) 55%, var(--bg-bot) 100%);
    color: var(--text);
    font-family: Inter, system-ui, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
  }

  a { color: inherit; text-decoration: none; }

  .site-header {
    background: var(--shell);
    padding: 14px clamp(18px, 5vw, 48px);
    display: flex; justify-content: space-between; align-items: center;
    box-shadow: 0 4px 12px rgba(0,0,0,.25);
    z-index: 10; flex-shrink: 0;
  }

  .logo-group { display: flex; align-items: center; gap: 16px; }
  .logo-group img { height: 36px; width: auto; border-radius: 8px; }

  .header-cta {
    color: var(--btn-top);
    font-weight: 600; font-size: 0.9rem;
    padding: 8px 12px; border-radius: 8px;
    transition: background-color .2s;
  }

  .hero {
    flex-grow: 1;
    display: flex; align-items: center; justify-content: center;
    padding: clamp(28px, 6vw, 52px);
  }

  .hero-card {
    background: linear-gradient(180deg, var(--bg-top) 0%, var(--bg-mid) 55%, var(--bg-bot) 100%);
    width: min(1130px, 92vw);
    border-radius: var(--radius);
    box-shadow: 0 18px 48px rgba(0, 0, 0, .35);
    padding: clamp(60px, 10vw, 100px) clamp(24px, 5vw, 48px);
    text-align: center;
    display: grid; place-items: center;
  }

  .hero-inner {
    display: grid; gap: 16px;
    max-width: 1000px; justify-items: center;
  }

  .hero-title {
    margin: 0;
    font-size: clamp(36px, 6vw, 70px);
    line-height: 1.15; font-weight: 800; letter-spacing: .2px;
    color: var(--text);
    text-shadow: 0 4px 20px rgba(0,0,0,.3);
  }

  .hero-subtitle {
    margin: 0; color: var(--text-sub);
    font-size: clamp(18px, 3vw, 25px); font-weight: 500;
    max-width: 700px;
  }

  .deadline {
    margin: 12px 0; font-size: 1.2rem; font-weight: 700;
    padding: 15px 30px; background: rgba(0,0,0,.25);
    border-radius: 99px; border: 1px solid rgba(255,255,255,.1);
  }

  .cta-btn {
    display: inline-flex; align-items: center; gap: 12px;
    padding: 16px 32px; margin-top: 8px; border-radius: 9999px;
    background: linear-gradient(180deg, var(--btn-top) 0%, var(--btn-bot) 100%);
    color: var(--btn-text); font-weight: 700; letter-spacing: .3px; font-size: 1.1rem;
    box-shadow: 0 8px 20px rgba(30, 128, 255, .35);
    user-select: none; border: none; cursor: pointer;
    transition: transform .2s, box-shadow .2s;
  }

  .cta-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(30, 128, 255, .4);
  }

  .cta-icon {
    width: 18px; height: 18px; border-radius: 999px; background: #fff;
    display: grid; place-items: center;
  }

  .cta-icon::before {
    content: ""; width: 0; height: 0;
    border-left: 6px solid var(--btn-bot);
    border-top: 4px solid transparent; border-bottom: 4px solid transparent;
    margin-left: 2px;
  }

  .site-footer {
    background: var(--shell);
    padding: 20px clamp(18px, 5vw, 48px);
    display: flex; align-items: center; justify-content: center; gap: 10px;
    border-top: 1px solid rgba(255,255,255,.1);
    font-weight: 700; font-size: 20px; letter-spacing: .4px;
    opacity: .9; flex-shrink: 0;
  }
  `;

  return (
    <div className="page">
      <style dangerouslySetInnerHTML={{ __html: css }} />

      <header className="site-header">
        <div className="logo-group">
          <a target="_blank" href="https://devops.vn" aria-label="DevOps VietNam">
            <img
              src="https://devops.vn/uploads/images/2025/09/devops.vn-logo-2017-footer.png"
              alt="DevOps VietNam"
            />
          </a>
          <a target="_blank" href="https://dataonline.vn" aria-label="DataOnline">
            <img
              src="https://devops.vn/uploads/images/2025/10/dataonline.vn-logo-transparent-bg.png"
              alt="DataOnline"
            />
          </a>
        </div>
        <a target="_blank" href="https://dataonline.vn/sale-off/" className="header-cta">
          Nhận ưu đãi VPS giá rẻ
        </a>
      </header>

      <main className="hero">
        <section className="hero-card" aria-labelledby="title">
          <div className="hero-inner">
            <h1 id="title" className="hero-title">Dockerfile Contest 2025</h1>
            <p className="hero-subtitle">
              Chúc mừng bạn. Bạn đã Dockerfile thành công. Hãy thêm đuôi .txt vào file Dockerfile và gửi về DevOps VietNam.
              (Nếu kèm file giải thích, cơ hội đạt giải sẽ cao hơn)
            </p>
            <p className="deadline">Hạn nộp bài: 27.10.2025 - 10.11.2025</p>
            <a
              className="cta-btn"
              target="_blank"
              href="https://devops.vn/webinar/dockerfile-contest-2025/#form"
              aria-label="Gửi Dockerfile ngay"
              rel="noreferrer"
            >
              Gửi Dockerfile ngay
              <span className="cta-icon" aria-hidden="true"></span>
            </a>
          </div>
        </section>
      </main>

      <footer className="site-footer">
        <span>© 2025 DevOps VietNam. All rights reserved.</span>
      </footer>
    </div>
  );
}

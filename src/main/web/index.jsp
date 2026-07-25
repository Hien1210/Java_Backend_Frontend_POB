<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POB Food | Giao đồ ăn thần tốc</title>
    <meta name="description" content="Đặt đồ ăn nhanh chóng, tươi ngon giao tận cửa. Hàng ngàn món ăn hấp dẫn đang chờ bạn khám phá trên POB Food.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            /* Sang trọng, tone sáng đồng bộ voi trang User */
            --bg-color: #FAFAFA;
            --bg-alt: #FFFFFF;
            --text-main: #1A1A1A;
            --text-muted: #666666;

            /* Cam thương hiệu POB Food */
            --primary-color: #FF6B35;
            --primary-hover: #FF8C5A;
            --primary-light: #FFF0EB;
            --primary-light-border: #FFD4C2;
            --primary-glow: rgba(255, 107, 53, 0.35);

            /* Glassmorphism (kinh mo sang, van giu chieu sau) */
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-border: rgba(26, 26, 26, 0.08);
            --glass-shadow: 0 8px 32px 0 rgba(26, 26, 26, 0.08);

            --font-sans: 'Outfit', sans-serif;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            font-family: var(--font-sans);
            background-color: var(--bg-color);
            color: var(--text-main);
            line-height: 1.6;
            overflow-x: hidden;
        }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* Utilities */
        .container { width: 100%; max-width: 1200px; margin: 0 auto; padding: 0 2rem; }
        .text-primary { color: var(--primary-color); }
        .text-center { text-align: center; }
        .mt-4 { margin-top: 2rem; }
        .align-center { align-items: center; }

        /* Background Glow Effects */
        .bg-glow { position: absolute; border-radius: 50%; filter: blur(100px); z-index: -1; pointer-events: none; }
        .blob-1 { top: -10%; right: -5%; width: 500px; height: 500px; background: radial-gradient(circle, rgba(255,107,53,0.14) 0%, rgba(255,107,53,0) 70%); }
        .blob-2 { bottom: 20%; left: -10%; width: 600px; height: 600px; background: radial-gradient(circle, rgba(255,140,90,0.10) 0%, rgba(255,140,90,0) 70%); }

        /* Glassmorphism Navigation */
        .glass-nav {
            position: fixed; top: 0; left: 0; width: 100%; z-index: 1000;
            padding: 1.5rem 0; transition: all 0.4s ease; border-bottom: 1px solid transparent;
        }
        .glass-nav.scrolled {
            background: var(--glass-bg); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--glass-border); padding: 1rem 0;
        }
        .nav-container { display: flex; justify-content: space-between; align-items: center; }
        .logo a { font-size: 1.75rem; font-weight: 800; letter-spacing: -0.5px; color: var(--text-main); }
        .logo span { color: var(--primary-color); }
        .nav-links { display: flex; gap: 2.5rem; }
        .nav-links a { font-weight: 500; font-size: 1rem; color: var(--text-muted); transition: color 0.3s ease; position: relative; }
        .nav-links a:hover, .nav-links a.active { color: var(--text-main); }
        .nav-links a::after {
            content: ''; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%);
            width: 0; height: 3px; background-color: var(--primary-color); border-radius: 4px; transition: width 0.3s ease;
        }
        .nav-links a:hover::after, .nav-links a.active::after { width: 100%; }
        .nav-actions { display: flex; align-items: center; gap: 1.5rem; }
        .cart-icon { position: relative; cursor: pointer; color: var(--text-main); transition: transform 0.2s ease; }
        .cart-icon:hover { transform: scale(1.1); }
        .cart-badge {
            position: absolute; top: -8px; right: -8px; background: var(--primary-color); color: white;
            font-size: 0.75rem; font-weight: bold; width: 20px; height: 20px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center; border: 2px solid var(--bg-color);
        }

        /* Buttons */
        .btn {
            display: inline-flex; align-items: center; justify-content: center; padding: 0.875rem 2rem;
            border-radius: 50px; font-weight: 600; font-size: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); cursor: pointer; border: none; outline: none;
        }
        .btn-primary { background-color: var(--primary-color); color: white; box-shadow: 0 4px 14px var(--primary-glow); }
        .btn-primary:hover { background-color: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 8px 25px var(--primary-glow); }
        .btn-outline { background-color: transparent; color: var(--text-main); border: 1px solid #DDDDDD; backdrop-filter: blur(4px); }
        .btn-outline:hover { background-color: var(--primary-light); border-color: var(--primary-color); color: var(--primary-color); }

        /* Hero Section */
        .hero { position: relative; min-height: 100vh; display: flex; align-items: center; padding-top: 5rem; }
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 4rem; }
        .hero-grid { align-items: center; }
        .hero-content { max-width: 600px; z-index: 2; }
        .badge {
            display: inline-block; padding: 0.5rem 1rem; background: var(--primary-light);
            color: var(--primary-color); border-radius: 50px; font-weight: 600; font-size: 0.875rem;
            margin-bottom: 1.5rem; border: 1px solid var(--primary-light-border);
        }
        .hero-title { font-size: 4.5rem; font-weight: 800; line-height: 1.1; margin-bottom: 1.5rem; letter-spacing: -1px; }
        .hero-subtitle { font-size: 1.15rem; color: var(--text-muted); margin-bottom: 2.5rem; font-weight: 400; }

        /* Search Bar */
        .search-bar {
            display: flex; align-items: center; background: var(--glass-bg); border: 1px solid var(--glass-border);
            padding: 0.5rem; border-radius: 50px; backdrop-filter: blur(10px); box-shadow: var(--glass-shadow);
        }
        .search-icon { margin-left: 1rem; color: var(--text-muted); }
        .search-bar input {
            flex: 1; background: transparent; border: none; padding: 0.75rem 1rem;
            color: var(--text-main); font-size: 1rem; font-family: var(--font-sans); outline: none;
        }
        .search-bar input::placeholder { color: var(--text-muted); }
        .search-bar .btn { padding: 0.75rem 1.75rem; }

        /* Stats */
        .stats { display: flex; gap: 3rem; }
        .stat-item h4 { font-size: 2rem; font-weight: 800; color: var(--text-main); }
        .stat-item p { font-size: 0.875rem; color: var(--text-muted); }

        /* Hero Image */
        .hero-image { position: relative; z-index: 1; display: flex; justify-content: center; align-items: center; }
        .floating-food { position: relative; width: 100%; max-width: 600px; text-align: center; }
        .hero-food-img {
            width: 100%; max-width: 560px; height: auto; display: inline-block;
            filter: drop-shadow(0 30px 40px rgba(255,107,53,0.25));
            animation: float 6s ease-in-out infinite; transform-origin: center;
        }
        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(2deg); }
            100% { transform: translateY(0px) rotate(0deg); }
        }

        /* Sections General */
        .section { padding: 6rem 0; }
        .section-dark { background-color: var(--bg-alt); border-top: 1px solid var(--glass-border); border-bottom: 1px solid var(--glass-border); }
        .section-header { max-width: 600px; margin: 0 auto 3rem; }
        .section-title { font-size: 3rem; font-weight: 800; line-height: 1.2; margin-bottom: 1rem; letter-spacing: -0.5px; }
        .section-desc { font-size: 1.1rem; color: var(--text-muted); }

        /* Glass Panels */
        .glass-panel {
            background: rgba(255, 255, 255, 0.7); border: 1px solid var(--glass-border); border-radius: 24px;
            backdrop-filter: blur(10px); box-shadow: 0 4px 20px rgba(26,26,26,0.05);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .glass-panel:hover {
            background: #FFFFFF; border-color: var(--primary-light-border);
            transform: translateY(-10px); box-shadow: 0 20px 40px rgba(255,107,53,0.14);
        }

        /* Steps Grid */
        .steps-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
        .step-card { padding: 3rem 2rem; text-align: center; }
        .step-icon {
            font-size: 3rem; margin-bottom: 1.5rem; display: inline-block; padding: 1rem;
            background: var(--primary-light); border-radius: 20px; border: 1px solid var(--primary-light-border);
        }
        .step-card h3 { font-size: 1.5rem; margin-bottom: 1rem; }
        .step-card p { color: var(--text-muted); }

        /* Menu Grid */
        .menu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2.5rem; }
        .menu-card { padding: 1rem; display: flex; flex-direction: column; }
        .card-img-wrapper {
            position: relative; border-radius: 16px; overflow: hidden; height: 250px;
            background: linear-gradient(135deg, #241812, #4A2E1D);
            display: flex; align-items: center; justify-content: center;
        }
        .card-img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .menu-card:hover .card-img-wrapper img { transform: scale(1.1); }
        .card-badge {
            position: absolute; top: 1rem; left: 1rem; background: var(--primary-color); color: white;
            padding: 0.25rem 0.75rem; border-radius: 50px; font-size: 0.8rem; font-weight: 600; z-index: 2;
        }
        .emoji-img { font-size: 6rem; filter: drop-shadow(0 10px 10px rgba(0,0,0,0.5)); }
        .card-content { padding: 1.5rem 0.5rem 0.5rem; flex: 1; display: flex; flex-direction: column; }
        .card-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem; }
        .card-header h3 { font-size: 1.25rem; font-weight: 700; }
        .rating { background: #F5F5F5; color: var(--text-main); padding: 0.2rem 0.5rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; }
        .card-desc { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 1.5rem; flex: 1; }
        .card-footer { display: flex; justify-content: space-between; align-items: center; }
        .price { font-size: 1.5rem; font-weight: 800; color: var(--primary-color); }
        .btn-add {
            width: 40px; height: 40px; border-radius: 50%; background: var(--text-main); color: var(--bg-color);
            border: none; font-size: 1.5rem; cursor: pointer; display: flex; align-items: center;
            justify-content: center; transition: all 0.3s ease;
        }
        .btn-add:hover { background: var(--primary-color); color: white; transform: rotate(90deg); }

        /* App Section */
        .app-section { position: relative; overflow: hidden; }
        .features-list { margin-top: 2rem; }
        .features-list li { display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem; font-size: 1.1rem; }
        .features-list svg { width: 24px; height: 24px; flex-shrink: 0; }
        .app-buttons { display: flex; gap: 1rem; }
        .store-btn {
            display: flex; align-items: center; gap: 0.75rem; background: #FFFFFF;
            border: 1px solid var(--glass-border); padding: 0.5rem 1.25rem; border-radius: 12px;
            box-shadow: 0 2px 10px rgba(26,26,26,0.04); transition: all 0.3s ease;
        }
        .store-btn:hover { background: var(--primary-light); border-color: var(--primary-light-border); transform: translateY(-2px); }
        .store-icon { font-size: 1.5rem; }
        .store-text { display: flex; flex-direction: column; }
        .store-text span { font-size: 0.7rem; color: var(--text-muted); }
        .store-text strong { font-size: 1rem; font-weight: 600; }

        /* Phone Mockup */
        .phone-frame {
            width: 300px; height: 600px; margin: 0 auto; border-radius: 40px; border: 8px solid #2A3B5C;
            position: relative; background: #0B0F19; color: #E8E8E8;
            padding: 1rem; box-shadow: 0 30px 60px rgba(26,26,26,0.35);
        }
        .phone-notch {
            position: absolute; top: 0; left: 50%; transform: translateX(-50%); width: 120px; height: 25px;
            background: #2A3B5C; border-bottom-left-radius: 16px; border-bottom-right-radius: 16px; z-index: 10;
        }
        .phone-content { height: 100%; padding-top: 2rem; position: relative; }
        .phone-header { text-align: center; font-weight: 700; font-size: 1.25rem; margin-bottom: 1rem; }
        .phone-emoji-box {
            width: 100%; height: 180px; border-radius: 12px; margin-top: 1rem;
            background: linear-gradient(135deg, #241812, #4A2E1D);
            display: flex; align-items: center; justify-content: center; overflow: hidden;
        }
        .phone-emoji-box img { width: 100%; height: 100%; object-fit: cover; }
        .phone-status { background: rgba(255,255,255,0.1); padding: 1rem; border-radius: 12px; margin-top: 1rem; }

        /* Footer — giu nen toi lam diem nhan sang trong khep trang, tu khai bao lai bien mau chu */
        .footer {
            --text-main: #FFFFFF; --text-muted: #94A3B8;
            background: #0B0F19; color: var(--text-main);
            padding: 6rem 0 2rem; border-top: 1px solid rgba(255,255,255,0.04);
        }
        .footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 4rem; margin-bottom: 4rem; }
        .footer-brand h2 { font-size: 2rem; font-weight: 800; margin-bottom: 1rem; }
        .footer-brand span { color: var(--primary-color); }
        .footer-brand p { color: var(--text-muted); font-size: 0.95rem; max-width: 300px; }
        .footer-links h3, .footer-social h3 { font-size: 1.25rem; font-weight: 600; margin-bottom: 1.5rem; }
        .footer-links a { display: block; color: var(--text-muted); margin-bottom: 0.75rem; transition: color 0.3s ease; }
        .footer-links a:hover { color: var(--primary-color); }
        .social-icons { display: flex; gap: 1rem; }
        .social-icons a {
            width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.05);
            display: flex; align-items: center; justify-content: center; transition: all 0.3s ease;
            font-size: 0.875rem; font-weight: 600;
        }
        .social-icons a:hover { background: var(--primary-color); color: white; transform: translateY(-3px); }
        .footer-bottom {
            text-align: center; padding-top: 2rem; border-top: 1px solid rgba(255,255,255,0.05);
            color: var(--text-muted); font-size: 0.875rem;
        }

        /* Scroll Reveal */
        .reveal { opacity: 0; transform: translateY(40px); transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275); }
        .reveal.active { opacity: 1; transform: translateY(0); }
        .delay-1 { transition-delay: 0.1s; }
        .delay-2 { transition-delay: 0.2s; }
        .delay-3 { transition-delay: 0.3s; }

        /* Responsive */
        @media (max-width: 992px) {
            .two-col { grid-template-columns: 1fr; text-align: center; }
            .hero-content { margin: 0 auto; }
            .search-bar { max-width: 500px; margin: 0 auto; }
            .stats { justify-content: center; }
            .menu-grid { grid-template-columns: repeat(2, 1fr); }
            .footer-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .hero-title { font-size: 3rem; }
            .nav-links { display: none; }
            .steps-grid, .menu-grid { grid-template-columns: 1fr; }
            .footer-grid { grid-template-columns: 1fr; gap: 2rem; }
            .app-buttons { justify-content: center; }
            .hero-food-img { max-width: 320px; }
        }
    </style>
</head>
<body>

    <!-- Background Elements -->
    <div class="bg-glow blob-1"></div>
    <div class="bg-glow blob-2"></div>

    <header id="header" class="glass-nav">
        <div class="container nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/">POB<span>Food</span></a>
            </div>
            <nav class="nav-links">
                <a href="#home" class="active">Trang chủ</a>
                <a href="#how-it-works">Cách hoạt động</a>
                <a href="#popular">Món nổi bật</a>
                <a href="#app">Ứng dụng</a>
            </nav>
            <div class="nav-actions">
                <div class="cart-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                </div>
                <a href="${pageContext.request.contextPath}/dangnhap" class="btn btn-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/dangky" class="btn btn-primary">Đăng ký</a>
            </div>
        </div>
    </header>

    <main>
        <!-- Hero Section -->
        <section id="home" class="hero">
            <div class="container two-col hero-grid">
                <div class="hero-content reveal">
                    <div class="badge">🔥 Giao hàng hỏa tốc trong 15 phút</div>
                    <h1 class="hero-title">Đói bụng?<br>Đã có <span class="text-primary">POB Food!</span></h1>
                    <p class="hero-subtitle">Khám phá hàng ngàn món ăn ngon từ các nhà hàng hàng đầu. Đặt hàng ngay để được giao tận cửa khi còn nóng hổi.</p>

                    <form class="search-bar" action="${pageContext.request.contextPath}/dangnhap" method="get">
                        <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input type="text" name="q" placeholder="Bạn muốn ăn gì hôm nay? (Burger, Pizza...)">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                    </form>

                    <div class="stats mt-4">
                        <div class="stat-item">
                            <h4>50+</h4>
                            <p>Cửa hàng</p>
                        </div>
                        <div class="stat-item">
                            <h4>500+</h4>
                            <p>Món ăn</p>
                        </div>
                        <div class="stat-item">
                            <h4>4.8</h4>
                            <p>Đánh giá sao</p>
                        </div>
                    </div>
                </div>
                <div class="hero-image reveal delay-1">
                    <div class="floating-food">
                        <img src="${pageContext.request.contextPath}/assets/img/burger_hero.png" alt="Burger phô mai bò nướng" class="hero-food-img">
                    </div>
                </div>
            </div>
        </section>

        <!-- How It Works Section -->
        <section id="how-it-works" class="section section-dark">
            <div class="container">
                <div class="section-header reveal text-center">
                    <h2 class="section-title">Đặt Đồ Ăn <span class="text-primary">Dễ Dàng</span></h2>
                    <p class="section-desc">Chỉ với 3 bước đơn giản, món ăn yêu thích sẽ có mặt ngay trước cửa nhà bạn.</p>
                </div>

                <div class="steps-grid mt-4">
                    <div class="step-card glass-panel reveal delay-1">
                        <div class="step-icon">📱</div>
                        <h3>1. Chọn Món Ăn</h3>
                        <p>Duyệt qua hàng ngàn thực đơn phong phú từ các nhà hàng xung quanh bạn.</p>
                    </div>
                    <div class="step-card glass-panel reveal delay-2">
                        <div class="step-icon">💳</div>
                        <h3>2. Thanh Toán Chạm</h3>
                        <p>Thanh toán nhanh chóng, an toàn qua thẻ hoặc các ví điện tử phổ biến.</p>
                    </div>
                    <div class="step-card glass-panel reveal delay-3">
                        <div class="step-icon">🛵</div>
                        <h3>3. Nhận Đồ Ăn</h3>
                        <p>Theo dõi tài xế trên bản đồ trực tiếp và nhận thức ăn nóng hổi.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Popular Menu Section -->
        <section id="popular" class="section">
            <div class="container">
                <div class="section-header reveal">
                    <h2 class="section-title">Món Ngon <span class="text-primary">Nổi Bật</span></h2>
                    <p class="section-desc">Những món ăn được đặt nhiều nhất trên POB Food tuần này.</p>
                </div>

                <div class="menu-grid mt-4">
                    <div class="menu-card glass-panel reveal delay-1">
                        <div class="card-img-wrapper">
                            <img src="${pageContext.request.contextPath}/assets/img/burger_hero.png" alt="Double Cheeseburger">
                            <div class="card-badge">Bán chạy</div>
                        </div>
                        <div class="card-content">
                            <div class="card-header">
                                <h3>Double Cheeseburger</h3>
                                <div class="rating">⭐ 4.9</div>
                            </div>
                            <p class="card-desc">Bò nướng than hoa, phô mai cheddar, sốt đặc biệt.</p>
                            <div class="card-footer">
                                <span class="price">89.000 ₫</span>
                                <button class="btn-add" type="button">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="menu-card glass-panel reveal delay-2">
                        <div class="card-img-wrapper">
                            <img src="${pageContext.request.contextPath}/assets/img/pizza_dish.png" alt="Pizza Pepperoni">
                            <div class="card-badge">Giảm 20%</div>
                        </div>
                        <div class="card-content">
                            <div class="card-header">
                                <h3>Pizza Pepperoni (L)</h3>
                                <div class="rating">⭐ 4.8</div>
                            </div>
                            <p class="card-desc">Đế mỏng giòn, phô mai mozzarella ngập tràn, pepperoni thơm lừng.</p>
                            <div class="card-footer">
                                <span class="price">159.000 ₫</span>
                                <button class="btn-add" type="button">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="menu-card glass-panel reveal delay-3">
                        <div class="card-img-wrapper">
                            <div class="emoji-img">🍣</div>
                        </div>
                        <div class="card-content">
                            <div class="card-header">
                                <h3>Set Sushi Thượng Hạng</h3>
                                <div class="rating">⭐ 5.0</div>
                            </div>
                            <p class="card-desc">Cá hồi tươi Na Uy, cá ngừ đại dương, trứng cá tuyết.</p>
                            <div class="card-footer">
                                <span class="price">329.000 ₫</span>
                                <button class="btn-add" type="button">+</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4 reveal delay-1" style="margin-top: 3rem;">
                    <a href="${pageContext.request.contextPath}/dangnhap" class="btn btn-outline">Xem Toàn Bộ Thực Đơn</a>
                </div>
            </div>
        </section>

        <!-- App Download Section -->
        <section id="app" class="section app-section">
            <div class="container two-col align-center">
                <div class="app-image reveal">
                    <div class="phone-frame glass-panel">
                        <div class="phone-notch"></div>
                        <div class="phone-content">
                            <div class="phone-header">POB Food</div>
                            <div class="phone-emoji-box">
                                <img src="${pageContext.request.contextPath}/assets/img/pizza_dish.png" alt="Pizza đang giao">
                            </div>
                            <div class="phone-status">
                                Đang giao hàng...<br>Tài xế cách bạn 2km.
                            </div>
                        </div>
                    </div>
                </div>
                <div class="app-content reveal delay-1">
                    <h2 class="section-title">Trải Nghiệm <br>Siêu Tốc Trên App</h2>
                    <p class="section-desc">Đăng ký tài khoản POB Food ngay hôm nay để nhận mã giảm giá cho đơn hàng đầu tiên và nhiều ưu đãi độc quyền khác.</p>
                    <ul class="features-list">
                        <li><svg viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg> Theo dõi đơn hàng theo thời gian thực</li>
                        <li><svg viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg> Tích điểm đổi quà hấp dẫn</li>
                        <li><svg viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg> Hàng ngàn mã Freeship mỗi ngày</li>
                    </ul>
                    <div class="app-buttons mt-4">
                        <a href="${pageContext.request.contextPath}/dangky" class="store-btn">
                            <div class="store-icon">👤</div>
                            <div class="store-text">
                                <span>Bắt đầu ngay</span>
                                <strong>Đăng ký tài khoản</strong>
                            </div>
                        </a>
                        <a href="${pageContext.request.contextPath}/dangky-shop" class="store-btn">
                            <div class="store-icon">🏪</div>
                            <div class="store-text">
                                <span>Hợp tác cùng</span>
                                <strong>Đăng ký cửa hàng</strong>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-brand">
                    <h2>POB<span>Food</span></h2>
                    <p>Nền tảng giao đồ ăn nhanh chóng, tiện lợi và uy tín nhất Việt Nam. Phục vụ bạn 24/7.</p>
                </div>
                <div class="footer-links">
                    <h3>Về POB Food</h3>
                    <a href="#">Giới thiệu</a>
                    <a href="${pageContext.request.contextPath}/dangky-shipper">Trở thành shipper</a>
                    <a href="${pageContext.request.contextPath}/dangky-shop">Đăng ký cửa hàng</a>
                </div>
                <div class="footer-links">
                    <h3>Hỗ trợ</h3>
                    <a href="#">Trung tâm trợ giúp</a>
                    <a href="#">Hướng dẫn đặt hàng</a>
                    <a href="#">Chính sách bảo mật</a>
                </div>
                <div class="footer-social">
                    <h3>Kết nối</h3>
                    <div class="social-icons">
                        <a href="#">FB</a>
                        <a href="#">IG</a>
                        <a href="#">TW</a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 POB Food. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        /* Navbar background on scroll */
        var header = document.getElementById('header');
        function onScroll() {
            if (window.scrollY > 40) header.classList.add('scrolled');
            else header.classList.remove('scrolled');
        }
        window.addEventListener('scroll', onScroll);
        onScroll();

        /* Scroll reveal animation */
        var revealEls = document.querySelectorAll('.reveal');
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.15 });
        revealEls.forEach(function(el) { observer.observe(el); });

        /* Active nav link on scroll */
        var sections = document.querySelectorAll('main section[id]');
        var navLinks = document.querySelectorAll('.nav-links a');
        window.addEventListener('scroll', function() {
            var current = '';
            sections.forEach(function(sec) {
                var top = sec.offsetTop - 120;
                if (window.scrollY >= top) current = sec.getAttribute('id');
            });
            navLinks.forEach(function(link) {
                link.classList.remove('active');
                if (link.getAttribute('href') === '#' + current) link.classList.add('active');
            });
        });
    </script>
</body>
</html>

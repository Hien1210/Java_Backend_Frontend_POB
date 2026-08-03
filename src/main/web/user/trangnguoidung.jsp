<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<<<<<<< HEAD
<<<<<<< HEAD
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá món ăn - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }

        .navbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            box-shadow: 0 1px 4px rgba(0,0,0,.06);
            position: sticky; top: 0; z-index: 50;
=======
<<<<<<< HEAD
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POB Food – Đặt đồ ăn ngon</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Be Vietnam Pro', 'Inter', system-ui, -apple-system, sans-serif;
            background: #FAFAFA;
            color: #1A1A1A;
            min-height: 100vh;
        }
        a { text-decoration: none; color: inherit; }

        /* ── VARIABLES: light theme trắng sạch, trẻ trung ── */
        :root {
            --primary: #FF6B35;
            --primary-hover: #FF8C5A;
            --primary-light: #FFF0EB;
            --primary-light-border: #FFD4C2;
            --primary-dark-text: #CC4A1A;
            --secondary: #FF8C5A;
            --accent-pink: #FF6B35;
            --white: #ffffff;
            --bg-page: #FAFAFA;
            --bg-panel: #FFFFFF;
            --bg-panel-solid: #FFFFFF;
            --bg-input: #F5F5F5;
            --border-color: #EEEEEE;
            --text-main: #1A1A1A;
            --text-muted: #666666;
            --text-dim: #999999;
            --success: #2E9E5B;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 12px;
            --shadow-sm: 0 2px 10px rgba(0,0,0,.05);
            --shadow-md: 0 8px 26px rgba(0,0,0,.08);
            --shadow-lg: 0 20px 55px rgba(0,0,0,.12);
            --glow-primary: 0 4px 14px rgba(255,107,53,.28);
        }

        .starfield { display: none; }
        .banner-section, .categories-section { position: relative; }

        /* ══════════ NAVBAR ══════════ */
        .navbar {
            background: #FFFFFF;
            border-bottom: 1px solid var(--border-color);
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-inner {
            max-width: 1200px; margin: 0 auto;
            padding: 0 20px;
            height: 64px;
            display: flex; align-items: center; gap: 16px;
        }
        .logo {
            display: flex; align-items: center; gap: 10px;
            flex-shrink: 0;
        }
        .logo-mark {
            width: 40px; height: 40px; border-radius: var(--radius-sm);
            background: var(--primary);
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: var(--white);
            letter-spacing: .5px;
            box-shadow: var(--glow-primary);
        }
        .logo-text {
            font-size: 18px; font-weight: 500; color: var(--text-main);
>>>>>>> origin/DUNGLAILAPTRINH_00306
        }
        .logo-text span { color: var(--primary); }

        .hero {
            background: linear-gradient(140deg, #1a2035 0%, #0f1624 100%);
            padding: 56px 24px 72px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before { content: ''; position: absolute; top: -60px; right: -60px; width: 220px; height: 220px; border-radius: 50%; background: radial-gradient(circle, rgba(16,185,129,0.18) 0%, transparent 70%); }

        .search-box {
            position: relative;
            max-width: 560px;
            margin: 0 auto;
        }
        .search-box input {
            width: 100%;
<<<<<<< HEAD
            padding: 14px 20px 14px 48px;
            border-radius: 14px;
            border: none;
            font-size: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,.15);
            outline: none;
        }
        .search-icon {
            position: absolute;
            left: 16px; top: 50%;
=======
            padding: 10px 16px 10px 42px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            background: #F5F5F5;
            color: var(--text-main);
            outline: none;
            transition: background .2s, box-shadow .2s;
        }
        .search-wrap input::placeholder { color: #999999; }
        .search-wrap input:focus {
            background: #FFFFFF;
            box-shadow: 0 0 0 2px var(--primary-light-border);
        }
        .search-wrap .s-icon {
            position: absolute; left: 14px; top: 50%;
>>>>>>> origin/DUNGLAILAPTRINH_00306
            transform: translateY(-50%);
            font-size: 18px;
            pointer-events: none;
        }

<<<<<<< HEAD
        .shop-card {
            background: #fff;
            border-radius: 18px;
            border: 1px solid #f0f0f0;
            box-shadow: 0 2px 8px rgba(0,0,0,.06);
            transition: transform .18s, box-shadow .18s;
=======
        /* Nav actions */
        .nav-actions { display: flex; align-items: center; gap: 4px; margin-left: auto; }
        .nav-link {
            display: flex; align-items: center; gap: 6px;
            padding: 8px 13px; border-radius: 50px;
            font-size: 13.5px; font-weight: 500; color: #444;
            transition: background .15s, color .15s;
        }
        .nav-link:hover { background: var(--primary-light); color: var(--primary); }

        /* Avatar + Dropdown */
        .avatar-wrap { position: relative; margin-left: 6px; }
        .avatar-btn {
            width: 40px; height: 40px; border-radius: 50%;
            background: var(--primary);
            color: var(--white); font-size: 15px; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; border: 2.5px solid #FFFFFF;
            outline: 2px solid var(--primary-light-border);
            overflow: hidden;
            transition: outline-color .2s;
        }
        .avatar-btn:hover { outline-color: var(--primary); }
        .dropdown {
            position: absolute; top: calc(100% + 10px); right: 0;
            background: #FFFFFF; border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            min-width: 210px; overflow: hidden;
            display: none; z-index: 200;
            animation: fadeDown .15s ease;
        }
        .dropdown.open { display: block; }
        @keyframes fadeDown {
            from { opacity:0; transform:translateY(-6px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .dropdown-header {
            padding: 14px 16px 12px;
            background: var(--primary-light);
            border-bottom: 1px solid var(--border-color);
        }
        .dropdown-header .d-name { font-size: 14px; font-weight: 500; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-dim); margin-top: 2px; }
        .dropdown a, .dropdown button {
            display: flex; align-items: center; gap: 9px;
            width: 100%; padding: 10px 16px;
            font-size: 13.5px; font-weight: 400; color: var(--text-muted);
            background: none; border: none; cursor: pointer; text-align: left;
            transition: background .12s, color .12s;
        }
        .dropdown a:hover, .dropdown button:hover { background: var(--bg-input); color: var(--primary); }
        .dropdown .d-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown .d-logout { color: #E5484D !important; }
        .dropdown .d-logout:hover { background: #FDEDED !important; }

        /* ══════════ BANNER SLIDER ══════════ */
        .banner-section { background: transparent; padding-bottom: 0; }
        .banner-wrap {
            max-width: 1200px; margin: 0 auto; padding: 20px 20px 0;
        }
        .slider {
            position: relative; border-radius: 14px;
            overflow: hidden; cursor: grab;
            box-shadow: none;
            border: .5px solid var(--primary-light-border);
            background: var(--primary-light);
        }
        .slider-track {
            display: flex;
            transition: transform .45s cubic-bezier(.4,0,.2,1);
        }
        .slide {
            min-width: 100%; height: 180px;
            display: flex; align-items: center; justify-content: space-between;
            padding: 32px 48px;
            flex-shrink: 0;
            position: relative; overflow: hidden;
            background: var(--primary-light);
        }
        .slide-content { position: relative; z-index: 2; }
        .slide-tag {
            display: inline-block; background: var(--primary-light-border);
            border-radius: 50px; padding: 3px 12px;
            font-size: 11px; font-weight: 700; color: var(--primary-dark-text);
            margin-bottom: 10px; letter-spacing: .5px; text-transform: uppercase;
        }
        .slide-title { font-size: 24px; font-weight: 500; color: var(--primary-dark-text); line-height: 1.2; margin-bottom: 8px; }
        .slide-sub { font-size: 13px; color: #E8825A; margin-bottom: 16px; }
        .slide-btn {
            display: inline-flex; align-items: center; gap: 6px;
            background: var(--primary);
            border-radius: 50px;
            padding: 8px 20px; font-size: 13px; font-weight: 600;
            color: #fff; cursor: pointer; border: none;
            box-shadow: var(--glow-primary);
            transition: background .15s, transform .15s;
        }
        .slide-btn:hover { background: var(--primary-hover); transform: translateY(-2px); }
        .slide-emoji {
            position: absolute; right: 40px; bottom: -10px;
            font-size: 100px; opacity: .18; pointer-events: none;
            transform: rotate(-15deg);
            z-index: 1;
        }

        /* Slider controls */
        .slider-dots {
            display: flex; justify-content: center; gap: 7px;
            padding: 14px 0;
        }
        .dot {
            width: 8px; height: 8px; border-radius: 50%;
            background: var(--border-color); cursor: pointer;
            transition: background .2s, width .2s;
            border: none; outline: none;
        }
        .dot.active { background: var(--primary); width: 24px; border-radius: 50px; }

        /* ══════════ HERO SEARCH (mobile fallback shown below banner) ══════════ */
        .hero-search-bar {
            padding: 16px 20px 20px;
            display: none;
        }
        .hero-search-bar input {
            width: 100%; padding: 12px 16px 12px 44px;
            border: none; border-radius: 10px;
            font-size: 14px; background: #F5F5F5; color: var(--text-main); outline: none;
            transition: box-shadow .2s;
        }
        .hero-search-bar input::placeholder { color: #999999; }
        .hero-search-bar input:focus { box-shadow: 0 0 0 2px var(--primary-light-border); background: #FFFFFF; }
        .hero-search-bar .hs-icon { position: absolute; left: 34px; top: 50%; transform: translateY(-50%); font-size: 17px; pointer-events: none; }
        .hs-wrap { position: relative; }

        /* ══════════ CATEGORIES ══════════ */
        .categories-section {
            background: transparent;
            border-bottom: 1px solid var(--border-color);
        }
        .section-inner { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .cat-scroll {
            display: flex; gap: 8px;
            overflow-x: auto; padding: 18px 0;
            scrollbar-width: none;
        }
        .cat-scroll::-webkit-scrollbar { display: none; }
        .cat-pill {
            display: flex; flex-direction: column; align-items: center; gap: 5px;
            flex-shrink: 0;
            cursor: pointer; padding: 12px 16px;
            border-radius: var(--radius-md);
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            transition: border-color .15s, background .15s, transform .15s;
            min-width: 74px;
        }
        .cat-pill:hover { background: var(--primary-light); border-color: var(--primary); transform: translateY(-2px); }
        .cat-pill.active { background: var(--primary-light); border-color: var(--primary); }
        .cat-pill .cat-icon {
            width: 44px; height: 44px; border-radius: 50%;
            background: var(--bg-input);
            display: flex; align-items: center; justify-content: center;
            font-size: 22px;
            box-shadow: var(--shadow-sm);
        }
        .cat-pill.active .cat-icon { background: var(--primary); }
        .cat-pill .cat-name { font-size: 11.5px; font-weight: 500; color: var(--text-muted); text-align: center; white-space: nowrap; }
        .cat-pill.active .cat-name { color: var(--primary); }

        /* ══════════ MAIN CONTENT ══════════ */
        .main { max-width: 1200px; margin: 0 auto; padding: 28px 20px 60px; }

        /* Section header */
        .sec-head {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 18px;
        }
        .sec-head-left { display: flex; align-items: center; gap: 10px; }
        .sec-title { font-size: 20px; font-weight: 500; color: var(--text-main); }
        .sec-badge {
            background: var(--primary-light); color: var(--primary);
            font-size: 12px; font-weight: 600;
            padding: 2px 10px; border-radius: 50px;
        }
        .sec-link { font-size: 13px; font-weight: 500; color: var(--primary); cursor: pointer; }
        .sec-link:hover { text-decoration: underline; }

        /* ══════════ SHOP / PRODUCT CARD ══════════ */
        .shop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 18px;
        }
        .shop-card {
            background: #FFFFFF;
            border-radius: 12px;
            border: .5px solid var(--border-color);
            box-shadow: var(--shadow-sm);
>>>>>>> origin/DUNGLAILAPTRINH_00306
            overflow: hidden;
            display: flex;
            flex-direction: column;
            cursor: pointer;
        }
        .shop-card:hover {
            transform: translateY(-4px);
<<<<<<< HEAD
            box-shadow: 0 8px 28px rgba(39,49,85,.16);
        }

        .shop-logo-wrap {
            background: linear-gradient(135deg, #f8f9ff, #eef0fa);
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 52px;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }
        .shop-logo-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
=======
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light-border);
        }
        .card-thumb {
            height: 160px; position: relative; overflow: hidden; flex-shrink: 0;
            background: var(--bg-input);
            display: flex; align-items: center; justify-content: center;
        }
        .card-thumb img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .35s;
        }
        .shop-card:hover .card-thumb img { transform: scale(1.07); }
        .card-thumb .thumb-fallback { font-size: 60px; opacity: .35; }
        .thumb-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to bottom, transparent 60%, rgba(0,0,0,.3) 100%);
        }

        /* Badges on thumb */
        .badge-open {
            position: absolute; top: 10px; left: 10px;
            display: flex; align-items: center; gap: 4px;
            background: var(--success); color: #fff;
            font-size: 10px; font-weight: 600;
            padding: 3px 10px; border-radius: 50px;
            box-shadow: 0 2px 6px rgba(0,0,0,.15);
        }
        .pulse-dot {
            width: 6px; height: 6px; border-radius: 50%;
            background: #fff; animation: blink 1.5s infinite;
>>>>>>> origin/DUNGLAILAPTRINH_00306
        }

        .shop-badge {
            position: absolute; top: 10px; right: 10px;
<<<<<<< HEAD
            background: #dcfce7; color: #16a34a;
            font-size: 11px; font-weight: 700;
            padding: 2px 8px; border-radius: 99px;
        }

        .shop-body { padding: 16px; flex: 1; display: flex; flex-direction: column; gap: 6px; }
        .shop-name { font-size: 15px; font-weight: 700; color: #1e293b; line-height: 1.3; }
        .shop-desc { font-size: 13px; color: #64748b;
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden; }
        .shop-meta { display: flex; align-items: flex-start; gap: 6px;
            font-size: 12px; color: #94a3b8; margin-top: 4px; }
        .shop-meta span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        .btn-order {
            margin: 0 16px 16px;
            padding: 10px;
            border-radius: 10px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            text-align: center;
            transition: opacity .15s;
=======
            background: var(--primary); color: #fff;
            font-size: 10.5px; font-weight: 700;
            padding: 3px 9px; border-radius: 50px;
        }

        /* Rating */
        .card-rating {
            position: absolute; bottom: 10px; left: 10px;
            display: flex; align-items: center; gap: 4px;
            background: rgba(255,255,255,.92);
            color: var(--text-main); font-size: 12px; font-weight: 600;
            padding: 3px 9px; border-radius: 50px;
        }
        .stars { color: #FFB100; font-size: 11px; letter-spacing: -1px; }

        /* Card body */
        .card-body { padding: 14px 14px 6px; flex: 1; display: flex; flex-direction: column; gap: 4px; }
        .card-name { font-size: 15px; font-weight: 500; color: var(--text-main); line-height: 1.3; }
        .card-desc {
            font-size: 12.5px; color: var(--text-dim); line-height: 1.5;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
>>>>>>> origin/DUNGLAILAPTRINH_00306
        }
        .btn-order:hover { opacity: .85; }

<<<<<<< HEAD
        .avatar-btn {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a2035, #2d3a6e);
            color: #fff;
            font-size: 14px;
            font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            border: none;
            position: relative;
            overflow: hidden;
        }
=======
        /* Card footer */
        .card-footer {
            display: flex; align-items: center; justify-content: space-between;
            padding: 10px 14px 14px;
        }
        .card-price { font-size: 14px; font-weight: 500; color: var(--primary); }
        .card-price small { font-size: 11px; font-weight: 400; color: var(--text-dim); }
        .btn-add {
            display: flex; align-items: center; gap: 5px;
            background: var(--primary); color: #fff;
            border: none; border-radius: var(--radius-sm);
            padding: 8px 16px; font-size: 13px; font-weight: 600;
            cursor: pointer;
            transition: background .15s, transform .1s;
            box-shadow: var(--glow-primary);
        }
        .btn-add:hover { background: var(--primary-hover); transform: scale(.97); }
>>>>>>> origin/DUNGLAILAPTRINH_00306

        .dropdown {
            position: absolute; top: calc(100% + 10px); right: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,.12);
            min-width: 190px;
            overflow: hidden;
            display: none;
            z-index: 100;
        }
        .dropdown.open { display: block; }
        .dropdown a, .dropdown button {
            display: flex; align-items: center; gap: 8px;
            width: 100%; padding: 11px 16px;
            font-size: 13px; font-weight: 500; color: #374151;
            text-align: left; background: none; border: none; cursor: pointer;
            text-decoration: none;
            transition: background .1s;
        }
        .dropdown a:hover, .dropdown button:hover { background: #f8fafc; }
        .dropdown .divider { height: 1px; background: #f0f0f0; margin: 4px 0; }

        .empty-state {
<<<<<<< HEAD
            text-align: center; padding: 64px 24px; color: #94a3b8;
        }
    </style>
=======
            text-align: center; padding: 80px 24px; color: var(--text-dim);
        }
        .empty-state .e-icon { font-size: 72px; margin-bottom: 16px; line-height: 1; opacity: .5; }
        .empty-state .e-title { font-size: 18px; font-weight: 500; color: var(--text-muted); }
        .empty-state .e-sub { font-size: 13px; margin-top: 6px; }

        /* ══════════ PROMO STRIP (banner freeship) ══════════ */
        .promo-strip {
            background: var(--primary-light);
            border: .5px solid var(--primary-light-border);
            border-radius: 14px;
            padding: 16px 20px;
            display: flex; align-items: center; gap: 14px;
            margin-bottom: 28px;
        }
        .promo-strip .p-icon { font-size: 30px; }
        .promo-strip .p-title { font-size: 14px; font-weight: 500; color: var(--primary-dark-text); }
        .promo-strip .p-sub { font-size: 12.5px; color: #E8825A; margin-top: 2px; }
        .promo-strip .p-code {
            margin-left: auto; background: var(--primary); color: #fff;
            font-size: 13px; font-weight: 700; padding: 7px 16px;
            border-radius: var(--radius-sm); letter-spacing: .5px; flex-shrink: 0;
            box-shadow: var(--glow-primary);
        }

        /* ══════════ FOOTER ══════════ */
        .site-footer {
            background: #FFFFFF; color: #999999;
            border-top: 1px solid var(--border-color);
        }
        .footer-inner {
            max-width: 1200px; margin: 0 auto; padding: 48px 20px 28px;
        }
        .footer-grid {
            display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 32px;
            padding-bottom: 40px; border-bottom: 1px solid var(--border-color);
        }
        .footer-brand .logo-mark { background: var(--primary); margin-bottom: 12px; }
        .footer-brand .brand-name { font-size: 18px; font-weight: 500; color: var(--text-main); margin-bottom: 8px; }
        .footer-brand p { font-size: 13px; line-height: 1.7; max-width: 240px; }
        .footer-socials { display: flex; gap: 10px; margin-top: 16px; }
        .social-btn {
            width: 36px; height: 36px; border-radius: var(--radius-sm);
            background: #F5F5F5; display: flex; align-items: center; justify-content: center;
            font-size: 17px; transition: background .15s;
        }
        .social-btn:hover { background: var(--primary-light); }
        .footer-col h4 { font-size: 14px; font-weight: 500; color: var(--text-main); margin-bottom: 14px; }
        .footer-col a {
            display: block; font-size: 13px; color: #999999; margin-bottom: 9px;
            transition: color .15s;
        }
        .footer-col a:hover { color: var(--primary); }
        .footer-bottom {
            display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;
            padding-top: 24px; font-size: 12px;
        }

        /* ══════════ RESPONSIVE ══════════ */
        @media (max-width: 768px) {
            .logo-text { display: none; }
            .search-wrap { display: none; }
            .hero-search-bar { display: block; }
            .nav-link span:last-child { display: none; }
            .slide { padding: 24px 28px; height: 170px; }
            .slide-title { font-size: 20px; }
            .slide-emoji { font-size: 70px; right: 20px; }
            .footer-grid { grid-template-columns: 1fr 1fr; gap: 24px; }
        }
        @media (max-width: 480px) {
            .footer-grid { grid-template-columns: 1fr; }
            .promo-strip { flex-wrap: wrap; }
            .promo-strip .p-code { width: 100%; text-align: center; }
        }
    </style>
=======
=======
>>>>>>> origin/DUNGLAILAPTRINH_00306
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>POBFood - Đói bụng? Có ngay!</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
<style>
:root {
    --bg:         #FFFBF8;
    --surface:    #FFFFFF;
    --surface-lt: #FFF4EC;
    --gold:       #FF5A1F;
    --gold-hover: #E14A0F;
    --text:       #241C15;
    --muted:      #8A7B6C;
    --border:     #F1E4D6;
    --font-h: 'Plus Jakarta Sans', sans-serif;
    --font-b: 'Plus Jakarta Sans', sans-serif;
    --tr: all 0.3s ease;
    --shadow: 0 14px 36px rgba(60,30,10,.14);
    --glow:   0 8px 22px rgba(255,90,31,.3);
}
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { font-family: var(--font-b); background: var(--bg); color: var(--text); line-height: 1.6; }
h1,h2,h3,h4,h5,h6 { font-family: var(--font-h); font-weight: 800; }
a { text-decoration: none; color: inherit; transition: var(--tr); }
ul { list-style: none; }
.container { max-width: 1180px; margin: 0 auto; padding: 0 20px; }
.section-padding { padding: 90px 0; }

/* ── SECTION HEADER ── */
.section-header { text-align: center; margin-bottom: 50px; }
.section-header .subtitle {
    font-size: .85rem; text-transform: uppercase; letter-spacing: 2px; font-weight: 700;
    color: var(--gold); display: block; margin-bottom: 10px;
}
.section-header .title { font-size: 2.4rem; color: var(--text); letter-spacing: -.5px; }

/* ── BUTTONS ── */
.btn-primary {
    display: inline-flex; align-items: center; gap: 8px;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover)); color: #fff;
    border: none; border-radius: 50px;
    padding: 14px 32px; font-size: 1rem; font-weight: 700;
    cursor: pointer; transition: var(--tr); text-align: center;
    font-family: var(--font-b); box-shadow: var(--glow);
}
.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 14px 30px rgba(255,90,31,.4); }
.btn-full { width: 100%; justify-content: center; }

/* ── NAVBAR ── */
.navbar {
    position: fixed; top: 0; left: 0; width: 100%;
    background: rgba(255,251,248,.92);
    backdrop-filter: blur(14px);
    z-index: 1000;
    border-bottom: 1px solid var(--border);
}
.nav-content {
    display: flex; justify-content: space-between; align-items: center; height: 76px;
}
.logo { display: flex; align-items: center; gap: 8px; }
.logo h1 { font-size: 1.7rem; letter-spacing: -.5px; }
.logo span { color: var(--gold); }
.logo-emoji { width: 32px; height: 32px; filter: drop-shadow(0 4px 8px rgba(255,90,31,.4)); }
.nav-links { display: flex; gap: 30px; }
.nav-links a { font-size: .92rem; font-weight: 600; color: var(--muted); }
.nav-links a:hover, .nav-links a.active { color: var(--gold); }

.nav-actions { display: flex; align-items: center; gap: 16px; }

/* Search in nav */
.nav-search { position: relative; }
.nav-search input {
    background: var(--surface-lt); border: 1.5px solid var(--border); border-radius: 50px;
    color: var(--text); font-family: var(--font-b); font-size: .85rem;
    padding: 9px 16px 9px 38px; width: 220px; transition: var(--tr);
}
.nav-search input:focus { outline: none; border-color: var(--gold); width: 280px; background: var(--surface); }
.nav-search input::placeholder { color: var(--muted); }
.nav-search i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: .85rem; pointer-events: none; }

/* Avatar dropdown */
.avatar-wrap { position: relative; }
.avatar-btn {
    width: 40px; height: 40px; border-radius: 50%;
    background: linear-gradient(135deg, var(--gold), var(--gold-hover));
    color: #FFF; font-size: 15px; font-weight: 800;
    border: none; cursor: pointer; font-family: var(--font-b);
    display: flex; align-items: center; justify-content: center;
    box-shadow: var(--glow);
}
.avatar-dropdown {
    position: absolute; top: calc(100% + 12px); right: 0;
    background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md, 16px);
    min-width: 220px; z-index: 200;
    display: none; box-shadow: var(--shadow);
    overflow: hidden;
}
.avatar-dropdown.open { display: block; }
.dd-head { padding: 16px 18px; border-bottom: 1px solid var(--border); background: var(--surface-lt); }
.dd-name { font-size: 14px; font-weight: 700; color: var(--text); }
.dd-email { font-size: 11.5px; color: var(--muted); margin-top: 3px; }
.dd-link, .dd-btn {
    display: flex; align-items: center; gap: 10px;
    width: 100%; padding: 12px 18px;
    font-size: 13px; font-weight: 600; color: var(--muted);
    background: none; border: none; cursor: pointer;
    font-family: var(--font-b); transition: var(--tr); text-align: left;
}
.dd-link i, .dd-btn i { color: var(--gold); width: 14px; }
.dd-link:hover, .dd-btn:hover { color: var(--gold); background: var(--primary-light, #FFF1E8); }
.dd-divider { height: 1px; background: var(--border); margin: 4px 0; }

.cart-btn {
    background: var(--surface-lt); border: 1.5px solid var(--border); border-radius: 50%;
    width: 42px; height: 42px; color: var(--text);
    font-size: 1.05rem; cursor: pointer; position: relative; transition: var(--tr);
    display: flex; align-items: center; justify-content: center;
}
.cart-btn:hover { color: var(--gold); border-color: var(--gold); }
.cart-count {
    position: absolute; top: -6px; right: -6px;
    background: var(--gold); color: #fff;
    font-size: .68rem; font-weight: 800;
    width: 19px; height: 19px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    border: 2px solid var(--bg);
}

/* ── HERO ── */
.hero {
    position: relative; min-height: 92vh; padding-top: 76px;
    background: radial-gradient(circle at 85% 15%, #FFE3D1 0%, transparent 45%),
                radial-gradient(circle at 10% 85%, #FFF3C4 0%, transparent 40%),
                var(--bg);
    display: flex; align-items: center; overflow: hidden;
}
.hero-grid { display: grid; grid-template-columns: 1.05fr .95fr; gap: 40px; align-items: center; }
.hero-content { max-width: 600px; position: relative; z-index: 2; }
.hero-badge {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 8px 18px; background: var(--surface); border: 1px solid var(--primary-border, #FFD3B8);
    border-radius: 50px; font-weight: 700; font-size: .85rem; color: var(--gold);
    margin-bottom: 22px; box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.hero-title { font-size: 3.6rem; line-height: 1.08; margin-bottom: 20px; letter-spacing: -1.5px; color: var(--text); }
.hero-title .accent { color: var(--gold); }
.hero-subtitle { font-size: 1.1rem; color: var(--muted); margin-bottom: 32px; font-weight: 500; max-width: 480px; }

.hero-search-wrap { margin-bottom: 32px; }
.hero-search {
    display: flex; align-items: center; gap: 0;
    background: var(--surface); border: 1.5px solid var(--border); border-radius: 60px;
    max-width: 520px; width: 100%; padding: 6px; box-shadow: var(--shadow);
}
.hero-search i { padding: 0 16px; color: var(--muted); }
.hero-search input {
    flex: 1; background: transparent; border: none;
    padding: 12px 0; color: var(--text); font-family: var(--font-b); font-size: .95rem;
    outline: none;
}
.hero-search input::placeholder { color: var(--muted); }
.hero-search .btn-search {
    background: linear-gradient(135deg, var(--gold), var(--gold-hover)); color: #fff;
    border: none; padding: 13px 26px; border-radius: 50px;
    font-family: var(--font-b); font-size: .88rem;
    font-weight: 700; cursor: pointer; transition: var(--tr);
}
.hero-search .btn-search:hover { transform: translateY(-1px); }

.hero-stats { display: flex; gap: 30px; margin-bottom: 8px; }
.hero-stat h4 { font-size: 1.7rem; font-weight: 800; color: var(--text); }
.hero-stat p { font-size: .82rem; color: var(--muted); font-weight: 600; }

/* ── HERO 3D FOOD VISUAL ── */
.hero-visual { position: relative; height: 480px; z-index: 1; }
.hero-orb {
    position: absolute; border-radius: 50%;
    background: radial-gradient(circle, #FFDAB9 0%, transparent 70%);
    filter: blur(10px);
}
.hero-3d-item {
    position: absolute; filter: drop-shadow(0 20px 30px rgba(60,30,10,.28));
    animation: floaty 6s ease-in-out infinite;
}
.hero-3d-item img { width: 100%; height: 100%; display: block; }
.hero-3d-main { width: 260px; height: 260px; top: 42%; left: 50%; transform: translate(-50%,-50%); animation-delay: 0s; z-index: 3; }
.hero-3d-a { width: 120px; height: 120px; top: 6%; left: 8%; animation-delay: .6s; z-index: 2; }
.hero-3d-b { width: 110px; height: 110px; bottom: 10%; left: 4%; animation-delay: 1.2s; z-index: 2; }
.hero-3d-c { width: 130px; height: 130px; top: 4%; right: 4%; animation-delay: .3s; z-index: 2; }
.hero-3d-d { width: 105px; height: 105px; bottom: 6%; right: 6%; animation-delay: .9s; z-index: 2; }

@keyframes floaty {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50%      { transform: translateY(-18px) rotate(4deg); }
}
.hero-3d-main.floaty-center { animation-name: floaty-center; }
@keyframes floaty-center {
    0%, 100% { transform: translate(-50%,-50%) translateY(0) rotate(0deg); }
    50%      { transform: translate(-50%,-50%) translateY(-16px) rotate(-3deg); }
}

/* ── CATEGORIES ── */
.categories { background: var(--surface-lt); }
.category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 22px;
}
.category-card {
    background: var(--surface); border: 1.5px solid var(--border); border-radius: var(--radius-lg, 22px);
    padding: 30px 16px; text-align: center; cursor: pointer; transition: var(--tr);
    box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.category-card .cat-icon { width: 58px; height: 58px; margin: 0 auto 14px; filter: drop-shadow(0 8px 14px rgba(60,30,10,.22)); transition: var(--tr); }
.category-card:hover .cat-icon { transform: scale(1.12) rotate(-6deg); }
.category-card h3 { font-size: .98rem; font-family: var(--font-b); font-weight: 700; }
.category-card:hover { transform: translateY(-8px); border-color: var(--gold); box-shadow: var(--shadow); }
.category-card.active { border-color: var(--gold); background: var(--primary-light, #FFF1E8); }

/* ── RESTAURANTS ── */
.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 32px;
}
.shop-card {
    background: var(--surface); border: 1.5px solid var(--border); border-radius: var(--radius-lg, 22px);
    overflow: hidden; transition: var(--tr); cursor: pointer;
    box-shadow: var(--shadow-sm, 0 2px 10px rgba(0,0,0,.05));
}
.shop-card:hover { transform: translateY(-6px); box-shadow: var(--shadow); border-color: var(--primary-border, #FFD3B8); }
.shop-img {
    width: 100%; height: 210px; object-fit: cover;
    background: var(--surface-lt); display: flex; align-items: center; justify-content: center;
    position: relative;
}
.shop-img img { width: 100%; height: 100%; object-fit: cover; }
.shop-img .fallback-icon { width: 70px; height: 70px; filter: drop-shadow(0 10px 16px rgba(60,30,10,.2)); }
.shop-info { padding: 22px; }
.shop-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; gap: 10px; }
.shop-title { font-size: 1.25rem; color: var(--text); }
.shop-badge-open {
    font-size: .72rem; font-weight: 700; letter-spacing: .3px; flex-shrink: 0;
    color: #15803D; text-transform: uppercase; background: var(--accent-green-lt, #EAFBF1);
    border: 1px solid #BBF0CF; border-radius: 50px;
    padding: 4px 12px; display: inline-flex; align-items: center; gap: 5px;
}
.shop-badge-open i { font-size: 6px; }
.shop-desc { color: var(--muted); font-size: .88rem; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.shop-meta { display: flex; flex-direction: column; gap: 6px; margin-bottom: 18px; }
.shop-meta-row { display: flex; align-items: center; gap: 8px; font-size: .83rem; color: var(--muted); }
.shop-meta-row i { color: var(--gold); width: 14px; }
.btn-menu {
    width: 100%; background: var(--primary-light, #FFF1E8); color: var(--gold);
    border: 1.5px solid var(--primary-border, #FFD3B8); padding: 12px; border-radius: 50px;
    font-family: var(--font-b); font-size: .85rem; font-weight: 700;
    cursor: pointer; transition: var(--tr);
}
.btn-menu:hover { background: var(--gold); color: #fff; box-shadow: var(--glow); border-color: var(--gold); }

/* EMPTY */
.empty-state {
    text-align: center; padding: 70px 24px; color: var(--muted);
    grid-column: 1 / -1;
}
.empty-state img { width: 84px; height: 84px; margin: 0 auto 16px; filter: drop-shadow(0 10px 16px rgba(60,30,10,.2)); }
.empty-state h3 { font-family: var(--font-h); font-size: 1.3rem; margin-bottom: 8px; color: var(--text); }
.empty-state p { font-size: .9rem; }

/* ── CART MODAL ── */
.cart-modal {
    position: fixed; inset: 0; z-index: 2000;
    display: flex; justify-content: flex-end;
    visibility: hidden; opacity: 0; transition: var(--tr);
}
.cart-modal.active { visibility: visible; opacity: 1; }
.cart-overlay {
    position: absolute; inset: 0;
    background: rgba(36,20,10,.55); backdrop-filter: blur(5px);
}
.cart-content {
    position: relative; width: 100%; max-width: 400px; height: 100%;
    background: var(--surface); display: flex; flex-direction: column;
    transform: translateX(100%); transition: transform .4s ease;
    box-shadow: -12px 0 40px rgba(60,30,10,.18);
}
.cart-modal.active .cart-content { transform: translateX(0); }
.cart-header {
    padding: 28px 26px; border-bottom: 1px solid var(--border);
    display: flex; justify-content: space-between; align-items: center;
}
.cart-header h2 { font-size: 1.4rem; }
.close-btn { background: var(--surface-lt); border: none; width: 34px; height: 34px; border-radius: 50%; color: var(--muted); font-size: 1.1rem; cursor: pointer; transition: var(--tr); }
.close-btn:hover { color: var(--gold); background: var(--primary-light, #FFF1E8); }
.cart-body { flex: 1; overflow-y: auto; padding: 26px; }
.cart-items { display: flex; flex-direction: column; gap: 18px; }
.empty-cart { text-align: center; color: var(--muted); padding: 50px 0; }
.empty-cart img { width: 78px; height: 78px; margin-bottom: 14px; }
.cart-item {
    display: flex; justify-content: space-between; align-items: center;
    padding-bottom: 18px; border-bottom: 1px solid var(--border);
}
.cart-item-info h4 { font-family: var(--font-b); font-weight: 700; margin-bottom: 5px; font-size: .95rem; }
.cart-item-info p { color: var(--gold); font-size: .9rem; font-weight: 700; }
.cart-item-actions { display: flex; align-items: center; gap: 10px; }
.qty-btn {
    background: var(--surface-lt); border: 1.5px solid var(--border); color: var(--text);
    width: 28px; height: 28px; border-radius: 50%; cursor: pointer; transition: var(--tr);
    display: flex; align-items: center; justify-content: center; font-size: .85rem;
}
.qty-btn:hover { border-color: var(--gold); color: var(--gold); }
.cart-footer {
    padding: 26px; border-top: 1px solid var(--border);
    background: var(--surface-lt);
}
.cart-total {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 18px; font-size: 1.05rem; font-weight: 700;
}
.total-price { color: var(--gold); font-size: 1.35rem; font-family: var(--font-h); }

/* ── FOOTER ── */
.footer { border-top: 1px solid var(--border); padding: 70px 0 20px; background: var(--surface-lt); }
.footer-content {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 50px; flex-wrap: wrap; gap: 40px;
}
.footer-brand h2 { font-size: 1.8rem; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
.footer-brand span { color: var(--gold); }
.footer-brand p { color: var(--muted); max-width: 320px; }
.footer-links { display: flex; gap: 28px; flex-wrap: wrap; }
.footer-links a { color: var(--muted); font-size: .9rem; font-weight: 600; }
.footer-links a:hover { color: var(--gold); }
.footer-bottom {
    text-align: center; color: var(--muted); font-size: .85rem;
    padding-top: 20px; border-top: 1px solid var(--border);
}

/* ── RESPONSIVE ── */
@media (max-width: 992px) {
    .hero-grid { grid-template-columns: 1fr; text-align: center; }
    .hero-content { margin: 0 auto; }
    .hero-search { margin: 0 auto; }
    .hero-stats { justify-content: center; }
    .hero-visual { height: 340px; margin-top: 20px; }
    .hero-3d-main { width: 190px; height: 190px; }
}
@media (max-width: 768px) {
    .hero-title { font-size: 2.6rem; }
    .nav-links, .nav-search { display: none; }
    .footer-content { flex-direction: column; text-align: center; }
    .footer-links { justify-content: center; }
    .restaurant-grid { grid-template-columns: 1fr; }
}
</style>
<<<<<<< HEAD
>>>>>>> ThanhHien_TY00243
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
>>>>>>> origin/DUNGLAILAPTRINH_00306
</head>
<body>

<<<<<<< HEAD
<<<<<<< HEAD
<!-- NAVBAR -->
<nav class="navbar px-5 py-3 flex items-center gap-4">
    <div class="w-9 h-9 rounded-xl flex items-center justify-center text-white font-extrabold text-sm flex-shrink-0"
         style="background: linear-gradient(135deg,#1a2035,#2d3a6e);">POB</div>
    <span class="text-base font-extrabold text-gray-800 hidden sm:block">POB Food</span>

    <div class="flex-1 max-w-xs mx-4 hidden md:block relative">
        <svg class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input id="navSearch" type="text" placeholder="Tìm quán..."
               class="w-full pl-8 pr-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:border-emerald-400"
=======
<<<<<<< HEAD
<!-- ═══════════════════ NAVBAR ═══════════════════ -->
<nav class="navbar">
    <div class="navbar-inner">
=======
<!-- ── NAVBAR ── -->
<header class="navbar">
    <div class="container nav-content">
>>>>>>> origin/DUNGLAILAPTRINH_00306
        <div class="logo">
            <img class="logo-emoji" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
            <h1>POBFood<span>.</span></h1>
        </div>

        <nav class="nav-links">
            <a href="#home" class="active">Trang chủ</a>
            <a href="#categories">Danh mục</a>
            <a href="#restaurants">Nhà hàng</a>
        </nav>

        <div class="nav-actions">
            <div class="nav-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input id="navSearch" type="text" placeholder="Tìm quán, món ăn..." oninput="filterShops(this.value)">
            </div>

            <div class="avatar-wrap" id="avatarWrap">
                <button class="avatar-btn" onclick="toggleDropdown()" aria-label="Tài khoản">
                    ${fn:substring(not empty account.fullName ? account.fullName : account.userName, 0, 1)}
                </button>
                <div class="avatar-dropdown" id="accountDropdown">
                    <div class="dd-head">
                        <div class="dd-name">${not empty account.fullName ? account.fullName : account.userName}</div>
                        <c:if test="${not empty account.email}"><div class="dd-email">${account.email}</div></c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/donhang" class="dd-link">
                        <i class="fa-solid fa-box"></i> Đơn hàng của tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/user/dia-chi" class="dd-link">
                        <i class="fa-solid fa-location-dot"></i> Địa chỉ giao hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/user/doi-mat-khau" class="dd-link">
                        <i class="fa-solid fa-lock"></i> Đổi mật khẩu
                    </a>
                    <div class="dd-divider"></div>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <button type="submit" class="dd-btn">
                            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                        </button>
                    </form>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/user/cart" class="cart-btn" aria-label="Giỏ hàng">
                <i class="fa-solid fa-bag-shopping"></i>
            </a>
        </div>
    </div>
</header>

<<<<<<< HEAD
<<<<<<< HEAD
<!-- Search bar mobile -->
<div class="hero-search-bar">
    <div class="hs-wrap">
        <span class="hs-icon">🔍</span>
        <input id="mobileSearch" type="text" placeholder="Tìm quán ăn, món ngon..."
>>>>>>> origin/DUNGLAILAPTRINH_00306
               oninput="filterShops(this.value)">
    </div>

    <div class="ml-auto flex items-center gap-5">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm font-medium text-gray-600 hover:text-emerald-600 flex items-center gap-1.5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
            <span class="hidden sm:inline">Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/user/dia-chi"
           class="text-sm font-medium text-gray-600 hover:text-emerald-600 flex items-center gap-1.5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
            <span class="hidden sm:inline">Địa chỉ</span>
        </a>

<<<<<<< HEAD
        <div class="relative" id="avatarWrap">
            <button class="avatar-btn" onclick="toggleDropdown()" title="${account.fullName}">
=======
<!-- ═══════════════════ CATEGORIES ═══════════════════ -->
<div class="categories-section">
    <div class="section-inner">
        <div class="cat-scroll" id="catScroll">
            <div class="cat-pill active" onclick="filterCat(this,'all')">
                <div class="cat-icon">🍽️</div>
                <div class="cat-name">Tất cả</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'com')">
                <div class="cat-icon">🍚</div>
                <div class="cat-name">Cơm</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'bun')">
                <div class="cat-icon">🍜</div>
                <div class="cat-name">Bún phở</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'banh')">
                <div class="cat-icon">🥪</div>
                <div class="cat-name">Bánh mì</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'tra')">
                <div class="cat-icon">🧋</div>
                <div class="cat-name">Trà sữa</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'burger')">
                <div class="cat-icon">🍔</div>
                <div class="cat-name">Burger</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'pizza')">
                <div class="cat-icon">🍕</div>
                <div class="cat-name">Pizza</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'nuoc')">
                <div class="cat-icon">🥤</div>
                <div class="cat-name">Đồ uống</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'sushi')">
                <div class="cat-icon">🍱</div>
                <div class="cat-name">Nhật Hàn</div>
            </div>
            <div class="cat-pill" onclick="filterCat(this,'xoi')">
                <div class="cat-icon">🍛</div>
                <div class="cat-name">Xôi chè</div>
=======
<!-- ── HERO ── -->
<section id="home" class="hero">
    <div class="container hero-grid">
        <div class="hero-content">
            <div class="hero-badge"><i class="fa-solid fa-bolt"></i> Giao hàng hỏa tốc trong 20 phút</div>
            <h2 class="hero-title">Đói bụng?<br>Đã có <span class="accent">POBFood!</span></h2>
            <p class="hero-subtitle">Khám phá hàng ngàn món ăn ngon từ các nhà hàng hàng đầu, giao tận nơi nóng hổi chỉ trong vài bước.</p>
            <div class="hero-search-wrap">
                <div class="hero-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input id="heroSearch" type="text" placeholder="Bạn muốn ăn gì hôm nay?" oninput="filterShops(this.value)">
                    <button class="btn-search" onclick="filterShops(document.getElementById('heroSearch').value)">Tìm kiếm</button>
                </div>
            </div>
            <div class="hero-stats">
                <div class="hero-stat"><h4>10k+</h4><p>Nhà hàng</p></div>
                <div class="hero-stat"><h4>30k+</h4><p>Món ăn</p></div>
                <div class="hero-stat"><h4>4.9 ★</h4><p>Đánh giá</p></div>
>>>>>>> origin/DUNGLAILAPTRINH_00306
            </div>
        </div>

<<<<<<< HEAD
<<<<<<< HEAD
<!-- ═══════════════════ MAIN CONTENT ═══════════════════ -->
<div class="main">

    <!-- Promo Strip -->
    <div class="promo-strip">
        <span class="p-icon">🎁</span>
        <div>
            <div class="p-title">Nhập mã để được giảm ngay 20K!</div>
            <div class="p-sub">Áp dụng cho đơn hàng từ 100K. Hạn dùng hôm nay.</div>
        </div>
        <div class="p-code">POBFOOD20</div>
    </div>

    <!-- Shop Grid -->
    <div class="sec-head">
        <div class="sec-head-left">
            <h2 class="sec-title">🏪 Cửa hàng đang mở cửa</h2>
            <span class="sec-badge" id="shopCount">
>>>>>>> origin/DUNGLAILAPTRINH_00306
                <c:choose>
                    <c:when test="${not empty account.avatarUrl}">
                        <img src="${account.avatarUrl}" alt="avatar"
                             style="width:100%;height:100%;object-fit:cover;">
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty account.fullName}">${fn:substring(account.fullName, 0, 1)}</c:when>
                            <c:otherwise>${fn:substring(account.userName, 0, 1)}</c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </button>
            <div class="dropdown" id="accountDropdown">
                <div class="px-4 py-3 border-b border-gray-100">
                    <div class="text-sm font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty account.fullName}">${account.fullName}</c:when>
                            <c:otherwise>${account.userName}</c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${not empty account.email}">
                        <div class="text-xs text-gray-400 mt-0.5">${account.email}</div>
                    </c:if>
                </div>
                <a href="${pageContext.request.contextPath}/user/donhang">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
                    Đơn hàng của tôi
                </a>
                <a href="${pageContext.request.contextPath}/user/dia-chi">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                    Địa chỉ giao hàng
                </a>
                <a href="${pageContext.request.contextPath}/user/doi-mat-khau">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    Đổi mật khẩu
                </a>
                <div class="divider"></div>
                <form action="${pageContext.request.contextPath}/logout" method="post">
                    <button type="submit">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                        Đăng xuất
                    </button>
                </form>
            </div>
        </div>
<<<<<<< HEAD
=======
        <span class="sec-link" onclick="filterShops('')">Xem tất cả</span>
=======
<!-- ===== CATEGORY CAROUSEL ===== -->
<c:if test="${not empty categories}">
<div class="cat-section">
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:2px;">
    <span style="font-size:13px;font-weight:600;color:var(--text-muted);">Khám phá theo loại</span>
    <span style="font-size:11.5px;color:#D1D5DB;">&larr; cuộn ngang &rarr;</span>
  </div>
  <div class="cat-scroll" id="catScroll">
    <button class="cat-pill active" onclick="filterCategory('all', this)">Tất cả</button>
    <c:forEach var="cat" items="${categories}">
      <button class="cat-pill" data-cat="${fn:escapeXml(cat.categoryName)}" onclick="filterCategory('${fn:escapeXml(cat.categoryName)}', this)">${fn:escapeXml(cat.categoryName)}</button>
    </c:forEach>
  </div>
</div>
</c:if>

<!-- ===== SHOP GRID ===== -->
<div class="shop-section">
  <div class="section-head">
    <div class="left">
      <div class="section-title">Cửa hàng đang mở</div>
      <div class="section-sub" id="shopCount">
        <c:choose>
          <c:when test="${empty shops}">0 cửa hàng</c:when>
          <c:otherwise>${shops.size()} cửa hàng đang phục vụ</c:otherwise>
        </c:choose>
      </div>
>>>>>>> ThanhHien_TY00243
>>>>>>> origin/DUNGLAILAPTRINH_00306
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="relative z-10">
        <h1 class="text-3xl sm:text-4xl font-extrabold text-white mb-2">
            Hôm nay bạn muốn ăn gì?
        </h1>
        <p class="text-slate-300 text-base mb-6">Khám phá các quán ăn ngon đang phục vụ</p>
        <div class="search-box">
            <span class="search-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            </span>
            <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..."
                   oninput="filterShops(this.value)">
        </div>
    </div>
</div>

<!-- SHOP LIST -->
<div class="max-w-6xl mx-auto px-4 py-8">

    <div class="flex items-center justify-between mb-6">
        <div>
            <div class="text-xl font-extrabold text-gray-800">Cửa hàng đang hoạt động</div>
            <div class="text-sm text-gray-400 mt-1" id="shopCount">
                <c:choose>
                    <c:when test="${empty shops}">0 cửa hàng</c:when>
                    <c:otherwise>${shops.size()} cửa hàng</c:otherwise>
                </c:choose>
            </div>
        </div>
        <span class="text-sm font-semibold text-emerald-600 cursor-pointer hover:text-emerald-700" onclick="filterShops('')">Xem tất cả</span>
    </div>

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> origin/DUNGLAILAPTRINH_00306
    <c:choose>
        <c:when test="${empty shops}">
            <div class="empty-state">
                <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-4"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
                <p class="text-lg font-semibold text-gray-500">Chưa có cửa hàng nào mở cửa</p>
                <p class="text-sm mt-1">Vui lòng quay lại sau nhé!</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5" id="shopGrid">
                <c:forEach var="shop" items="${shops}">
                    <div class="shop-card"
                         data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}"
                         data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}"
                         data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}"
                         onclick="goToShop(${shop.id})">

                        <div class="shop-logo-wrap">
                            <c:choose>
                                <c:when test="${not empty shop.shopLogo}">
                                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                                         onerror="this.parentNode.innerHTML='<svg width=\'44\' height=\'44\' viewBox=\'0 0 24 24\' fill=\'none\' stroke=\'#94a3b8\' stroke-width=\'1.5\'><path d=\'M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2\'/><path d=\'M7 2v20\'/><path d=\'M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7\'/></svg><span class=\'shop-badge\'>● Đang mở</span>';">
                                </c:when>
                                <c:otherwise>
                                    <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" stroke-width="1.5"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
                                </c:otherwise>
                            </c:choose>
                            <span class="shop-badge">● Đang mở</span>
                        </div>

                        <div class="shop-body">
                            <div class="shop-name">${shop.shopName}</div>
                            <c:if test="${not empty shop.shopDescription}">
                                <div class="shop-desc">${shop.shopDescription}</div>
                            </c:if>
                            <c:if test="${not empty shop.shopAddress}">
                                <div class="shop-meta">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px;"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                    <span title="${shop.shopAddress}">${shop.shopAddress}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty shop.shopPhone}">
                                <div class="shop-meta">
                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px;"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.362 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.338 1.85.573 2.81.7A2 2 0 0 1 22 16.92Z"/></svg>
                                    <span>${shop.shopPhone}</span>
                                </div>
                            </c:if>
                        </div>

                        <div class="btn-order">Xem thực đơn →</div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
<<<<<<< HEAD
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mx-auto mb-3"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                <p class="text-base font-semibold text-gray-500">Không tìm thấy quán nào</p>
                <p class="text-sm mt-1">Thử từ khoá khác nhé</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="text-center text-xs text-gray-400 py-8 border-t border-gray-100 mt-4">
    © 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</footer>
=======
                <div class="e-icon">🔍</div>
                <div class="e-title">Không tìm thấy quán nào</div>
                <div class="e-sub">Thử từ khoá khác nhé!</div>
=======
  <c:choose>
    <c:when test="${empty shops}">
      <div class="empty-state">
        <div class="empty-icon">
          <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
        </div>
        <div class="empty-title">Chưa có quán ăn nào</div>
        <div class="empty-hint">Vui lòng quay lại sau nhé!</div>
      </div>
    </c:when>
    <c:otherwise>
      <div class="shop-grid" id="shopGrid">
        <c:forEach var="shop" items="${shops}">
          <div class="shop-card" data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}" data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}" data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}" onclick="goToShop(${shop.id})">

            <div class="shop-img">
              <c:choose>
                <c:when test="${not empty shop.shopLogo}">
                  <img src="${shop.shopLogo}" alt="${fn:escapeXml(shop.shopName)}" onerror="this.style.visibility='hidden';this.nextElementSibling.style.display='flex';">
                  <svg class="fallback-icon" width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" style="display:none;position:absolute;"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
=======
        <div class="hero-visual">
            <div class="hero-3d-item hero-3d-main floaty-center">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Hamburger/3D/hamburger_3d.png" alt="Burger">
            </div>
            <div class="hero-3d-item hero-3d-a">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Pizza/3D/pizza_3d.png" alt="Pizza">
            </div>
            <div class="hero-3d-item hero-3d-b">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Bubble%20tea/3D/bubble_tea_3d.png" alt="Trà sữa">
            </div>
            <div class="hero-3d-item hero-3d-c">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Sushi/3D/sushi_3d.png" alt="Sushi">
            </div>
            <div class="hero-3d-item hero-3d-d">
                <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/French%20fries/3D/french_fries_3d.png" alt="Khoai tây chiên">
            </div>
        </div>
    </div>
</section>

<!-- ── CATEGORIES ── -->
<section id="categories" class="categories section-padding">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Lựa chọn của bạn</span>
            <h2 class="title">Danh Mục Ẩm Thực</h2>
        </div>
        <div class="category-grid">
            <c:choose>
                <c:when test="${not empty categories}">
                    <div class="category-card active" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                        <h3>Tất Cả</h3>
                    </div>
                    <c:set var="catIconsArr" value="${fn:split('Pizza|Sushi|Green salad|Cupcake|Taco|Spaghetti|Bento box|Hot beverage', '|')}" />
                    <c:set var="catIconFilesArr" value="${fn:split('pizza_3d.png|sushi_3d.png|green_salad_3d.png|cupcake_3d.png|taco_3d.png|spaghetti_3d.png|bento_box_3d.png|hot_beverage_3d.png', '|')}" />
                    <c:forEach var="cat" items="${categories}" varStatus="cs">
                        <c:set var="idx" value="${cs.index mod 8}" />
                        <div class="category-card"
                             data-cat="${fn:escapeXml(cat.categoryName)}"
                             onclick="filterCategory('${fn:escapeXml(cat.categoryName)}', this)">
                            <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/${catIconsArr[idx]}/3D/${catIconFilesArr[idx]}" alt="">
                            <h3>${fn:escapeXml(cat.categoryName)}</h3>
                        </div>
                    </c:forEach>
>>>>>>> origin/DUNGLAILAPTRINH_00306
                </c:when>
                <c:otherwise>
                    <div class="category-card active" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                        <h3>Tất Cả</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Sushi/3D/sushi_3d.png" alt="">
                        <h3>Hải Sản &amp; Sushi</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Green%20salad/3D/green_salad_3d.png" alt="">
                        <h3>Healthy &amp; Vegan</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Cupcake/3D/cupcake_3d.png" alt="">
                        <h3>Tráng Miệng</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Hamburger/3D/hamburger_3d.png" alt="">
                        <h3>Đồ Nướng</h3>
                    </div>
                    <div class="category-card" onclick="filterCategory('all', this)">
                        <img class="cat-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Bubble%20tea/3D/bubble_tea_3d.png" alt="">
                        <h3>Đồ Uống</h3>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- ── RESTAURANTS ── -->
<section id="restaurants" class="restaurants section-padding">
    <div class="container">
        <div class="section-header">
            <span class="subtitle">Đối tác độc quyền</span>
            <h2 class="title">Nhà Hàng Tuyển Chọn</h2>
        </div>

        <c:choose>
            <c:when test="${empty shops}">
                <div class="restaurant-grid">
                    <div class="empty-state">
                        <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
                        <h3>Chưa có nhà hàng nào</h3>
                        <p>Vui lòng quay lại sau nhé!</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="restaurant-grid" id="shopGrid">
                    <c:forEach var="shop" items="${shops}">
                        <div class="shop-card"
                             data-name="${fn:escapeXml(fn:toLowerCase(shop.shopName))}"
                             data-desc="${fn:escapeXml(fn:toLowerCase(shop.shopDescription))}"
                             data-addr="${fn:escapeXml(fn:toLowerCase(shop.shopAddress))}"
                             onclick="goToShop(${shop.id})">

                            <div class="shop-img">
                                <c:choose>
                                    <c:when test="${not empty shop.shopLogo}">
                                        <img src="${shop.shopLogo}" alt="${fn:escapeXml(shop.shopName)}"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='block';">
                                        <img class="fallback-icon" style="display:none;" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="fallback-icon" src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Fork%20and%20knife%20with%20plate/3D/fork_and_knife_with_plate_3d.png" alt="">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="shop-info">
                                <div class="shop-header">
                                    <h3 class="shop-title">${fn:escapeXml(shop.shopName)}</h3>
                                    <span class="shop-badge-open"><i class="fa-solid fa-circle"></i> Đang mở</span>
                                </div>
                                <c:if test="${not empty shop.shopDescription}">
                                    <p class="shop-desc">${fn:escapeXml(shop.shopDescription)}</p>
                                </c:if>
                                <div class="shop-meta">
                                    <c:if test="${not empty shop.shopAddress}">
                                        <div class="shop-meta-row">
                                            <i class="fa-solid fa-location-dot"></i>
                                            <span>${fn:escapeXml(shop.shopAddress)}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty shop.shopPhone}">
                                        <div class="shop-meta-row">
                                            <i class="fa-solid fa-phone"></i>
                                            <span>${fn:escapeXml(shop.shopPhone)}</span>
                                        </div>
                                    </c:if>
                                </div>
                                <button class="btn-menu" onclick="event.stopPropagation(); goToShop(${shop.id})">
                                    Xem Thực Đơn &nbsp;<i class="fa-solid fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div id="noResults" class="restaurant-grid" style="display:none;">
                    <div class="empty-state">
                        <img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Steaming%20bowl/3D/steaming_bowl_3d.png" alt="">
                        <h3>Không tìm thấy kết quả</h3>
                        <p>Hãy thử từ khoá khác nhé.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ── FOOTER ── -->
<footer class="footer">
    <div class="container footer-content">
        <div class="footer-brand">
            <h2>POBFood<span>.</span></h2>
            <p>Nền tảng giao đồ ăn nhanh chóng, tiện lợi và thơm ngon nhất dành cho bạn.</p>
        </div>
        <div class="footer-links">
            <a href="#">Về chúng tôi</a>
            <a href="#">Chính sách bảo mật</a>
            <a href="#">Điều khoản sử dụng</a>
            <a href="${pageContext.request.contextPath}/user/donhang">Đơn hàng</a>
            <a href="${pageContext.request.contextPath}/user/dia-chi">Địa chỉ</a>
        </div>
    </div>
    <div class="footer-bottom container">
        <p>&copy; 2026 POBFood. Đã đăng ký bản quyền.</p>
    </div>
</footer>
<<<<<<< HEAD
=======
<!-- ===== FOOTER ===== -->
<div class="footer">
  &copy; 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</div>
>>>>>>> ThanhHien_TY00243
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======
>>>>>>> origin/DUNGLAILAPTRINH_00306

<script>
/* ── NAVIGATION ── */
function goToShop(id) {
    window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + id;
}

<<<<<<< HEAD
    /* ── Search / filter shops ── */
    function filterShops(query) {
        // sync all search inputs
        ['navSearch','mobileSearch','heroSearch'].forEach(function(id) {
            var el = document.getElementById(id);
            if (el) el.value = query;
        });

        var q = query.toLowerCase().trim();
        var cards = document.querySelectorAll('#shopGrid .shop-card');
        if (!cards.length) return;

<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> origin/DUNGLAILAPTRINH_00306
        var visible = 0;
        cards.forEach(function(card) {
            var name = card.dataset.name || '';
            var desc = card.dataset.desc || '';
            var addr = card.dataset.addr || '';
            var match = !q || name.includes(q) || desc.includes(q) || addr.includes(q);
            card.style.display = match ? '' : 'none';
            if (match) visible++;
        });

        var noResults = document.getElementById('noResults');
        var countEl   = document.getElementById('shopCount');
        if (noResults) noResults.style.display = (visible === 0) ? 'block' : 'none';
        if (countEl) {
            countEl.textContent = q
                ? visible + ' cửa hàng khớp với "' + query + '"'
                : visible + ' cửa hàng';
        }
    }

    function toggleDropdown() {
        document.getElementById('accountDropdown').classList.toggle('open');
    }
    document.addEventListener('click', function(e) {
        var wrap = document.getElementById('avatarWrap');
        if (wrap && !wrap.contains(e.target)) {
            document.getElementById('accountDropdown').classList.remove('open');
        }
    });
<<<<<<< HEAD
=======
=======
function filterShops(query) {
    ['navSearch','heroSearch'].forEach(function(id) {
        var el = document.getElementById(id); if (el) el.value = query;
    });
    var q = query.toLowerCase().trim();
    var cards = document.querySelectorAll('#shopGrid .shop-card');
    if (!cards.length) return;
    var visible = 0;
    cards.forEach(function(c) {
        var match = !q || (c.dataset.name||'').includes(q) || (c.dataset.desc||'').includes(q) || (c.dataset.addr||'').includes(q);
        c.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    document.getElementById('noResults').style.display = visible === 0 ? 'grid' : 'none';
    if (q) document.querySelectorAll('.category-card').forEach(function(p) { p.classList.remove('active'); });
}
>>>>>>> origin/DUNGLAILAPTRINH_00306

function filterCategory(cat, btn) {
    document.querySelectorAll('.category-card').forEach(function(p) { p.classList.remove('active'); });
    btn.classList.add('active');
    ['navSearch','heroSearch'].forEach(function(id) { var el = document.getElementById(id); if (el) el.value = ''; });
    document.querySelectorAll('#shopGrid .shop-card').forEach(function(c) { c.style.display = ''; });
    var noRes = document.getElementById('noResults');
    if (noRes) noRes.style.display = 'none';
}

function toggleDropdown() {
    document.getElementById('accountDropdown').classList.toggle('open');
}
document.addEventListener('click', function(e) {
    var w = document.getElementById('avatarWrap');
    if (w && !w.contains(e.target)) document.getElementById('accountDropdown').classList.remove('open');
});
<<<<<<< HEAD
>>>>>>> ThanhHien_TY00243
>>>>>>> origin/DUNGLAILAPTRINH_00306
=======

/* ── CART ── */
var cart = [];

document.getElementById('cartBtn').addEventListener('click', function() {
    document.getElementById('cartModal').classList.add('active');
});
document.getElementById('closeCart').addEventListener('click', closeCartModal);
document.getElementById('cartOverlay').addEventListener('click', closeCartModal);

function closeCartModal() {
    document.getElementById('cartModal').classList.remove('active');
}

function updateCartUI() {
    var total = cart.reduce(function(s, i) { return s + i.price * i.qty; }, 0);
    var count = cart.reduce(function(s, i) { return s + i.qty; }, 0);
    document.getElementById('cartCount').textContent = count;
    document.getElementById('cartTotalPrice').textContent = total.toLocaleString('vi-VN') + ' ₫';

    var container = document.getElementById('cartItems');
    if (cart.length === 0) {
        container.innerHTML = '<div class="empty-cart"><img src="https://cdn.jsdelivr.net/gh/microsoft/fluentui-emoji@main/assets/Shopping%20cart/3D/shopping_cart_3d.png" alt=""><p>Giỏ hàng đang trống.</p></div>';
        return;
    }
    container.innerHTML = cart.map(function(item, idx) {
        return '<div class="cart-item">' +
            '<div class="cart-item-info"><h4>' + item.name + '</h4><p>' + (item.price * item.qty).toLocaleString('vi-VN') + ' ₫</p></div>' +
            '<div class="cart-item-actions">' +
                '<button class="qty-btn" onclick="changeQty(' + idx + ',-1)"><i class="fa-solid fa-minus"></i></button>' +
                '<span style="min-width:20px;text-align:center;">' + item.qty + '</span>' +
                '<button class="qty-btn" onclick="changeQty(' + idx + ',1)"><i class="fa-solid fa-plus"></i></button>' +
            '</div>' +
        '</div>';
    }).join('');
}

function changeQty(idx, delta) {
    cart[idx].qty = Math.max(0, cart[idx].qty + delta);
    if (cart[idx].qty === 0) cart.splice(idx, 1);
    updateCartUI();
}

document.getElementById('checkoutBtn').addEventListener('click', function() {
    if (cart.length === 0) { alert('Giỏ hàng đang trống!'); return; }
    window.location.href = '${pageContext.request.contextPath}/user/home';
});

updateCartUI();
>>>>>>> origin/DUNGLAILAPTRINH_00306
</script>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>

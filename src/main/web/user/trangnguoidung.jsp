<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
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
        }
        .logo-text span { color: var(--primary); }

        /* Search bar */
        .search-wrap {
            flex: 1; max-width: 480px;
            position: relative;
        }
        .search-wrap input {
            width: 100%;
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
            transform: translateY(-50%);
            font-size: 16px; pointer-events: none;
        }

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
            overflow: hidden;
            cursor: pointer;
            display: flex; flex-direction: column;
            transition: transform .22s cubic-bezier(.34,1.56,.64,1), box-shadow .22s, border-color .22s;
        }
        .shop-card:hover {
            transform: translateY(-4px);
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
        }
        @keyframes blink { 0%,100%{opacity:1} 50%{opacity:.3} }

        .badge-promo {
            position: absolute; top: 10px; right: 10px;
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
        }
        .card-meta {
            display: flex; align-items: center; gap: 6px;
            font-size: 12px; color: var(--text-dim); margin-top: 4px;
        }
        .card-meta .meta-sep { color: var(--border-color); }

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

        /* ══════════ EMPTY STATE ══════════ */
        .empty-state {
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
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tìm quán ăn - POB Food</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root {
  --primary: #FF7A30;
  --primary-dark: #D95A1A;
  --primary-light: rgba(255,122,48,.12);
  --bg-base: #FFF8F1;
  --bg-card: #FFFFFF;
  --text-main: #1C1E32;
  --text-muted: #6B7280;
  --hero-from: #1C1E32;
  --hero-to: #0f1624;
  --border: #E5E7EB;
  --shadow-sm: 0 1px 3px rgba(0,0,0,.06);
  --shadow-md: 0 4px 16px rgba(0,0,0,.08);
  --shadow-lg: 0 8px 28px rgba(0,0,0,.12);
}
* { font-family: 'Inter', system-ui, -apple-system, sans-serif; box-sizing: border-box; }
body { margin: 0; background: var(--bg-base); color: var(--text-main); }

/* NAVBAR */
.navbar {
  position: sticky; top: 0; z-index: 50;
  background: var(--bg-card);
  border-bottom: 1px solid var(--border);
  box-shadow: var(--shadow-sm);
  padding: 0 20px; height: 58px;
  display: flex; align-items: center; gap: 14px;
}
.nav-logo {
  width: 36px; height: 36px; border-radius: 10px;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  display: flex; align-items: center; justify-content: center;
  color: #fff; font-weight: 800; font-size: 14px; flex-shrink: 0;
}
.nav-brand { font-size: 16px; font-weight: 700; color: var(--text-main); white-space: nowrap; }
.nav-search {
  flex: 1; max-width: 420px; position: relative;
}
.nav-search input {
  width: 100%; padding: 9px 14px 9px 38px;
  border-radius: 10px; border: 1.5px solid var(--border);
  font-size: 13.5px; background: #F9FAFB;
  transition: border-color .15s, box-shadow .15s;
}
.nav-search input:focus {
  outline: none; border-color: var(--primary);
  box-shadow: 0 0 0 3px var(--primary-light);
}
.nav-search .s-icon {
  position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
  color: #9CA3AF; pointer-events: none;
}
.nav-links { display: flex; align-items: center; gap: 6px; margin-left: auto; }
.nav-link {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 8px 12px; border-radius: 8px;
  font-size: 13px; font-weight: 500; color: var(--text-muted);
  text-decoration: none; transition: all .15s; white-space: nowrap;
}
.nav-link:hover { background: var(--primary-light); color: var(--primary); }
.nav-link svg { flex-shrink: 0; }

/* AVATAR */
.avatar-btn {
  width: 34px; height: 34px; border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; font-size: 13px; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; border: none; position: relative;
}
.dropdown {
  position: absolute; top: calc(100% + 8px); right: 0;
  background: #fff; border: 1px solid var(--border);
  border-radius: 12px; box-shadow: var(--shadow-lg);
  min-width: 200px; overflow: hidden;
  display: none; z-index: 100;
}
.dropdown.open { display: block; }
.dropdown-header { padding: 14px 16px; border-bottom: 1px solid #F3F4F6; }
.dropdown-header .name { font-size: 13.5px; font-weight: 700; color: var(--text-main); }
.dropdown-header .email { font-size: 11.5px; color: #9CA3AF; margin-top: 2px; }
.dropdown a, .dropdown button {
  display: flex; align-items: center; gap: 8px;
  width: 100%; padding: 10px 16px;
  font-size: 13px; font-weight: 500; color: #4B5563;
  text-align: left; background: none; border: none;
  cursor: pointer; text-decoration: none; transition: background .1s;
}
.dropdown a:hover, .dropdown button:hover { background: #F9FAFB; color: var(--primary); }
.dropdown .divider { height: 1px; background: #F3F4F6; margin: 4px 0; }

/* HERO */
.hero {
  background: linear-gradient(135deg, var(--hero-from) 0%, #1a1f3a 50%, var(--hero-to) 100%);
  padding: 36px 24px 40px; text-align: center;
  position: relative; overflow: hidden;
}
.hero::before {
  content: ''; position: absolute; top: -80px; right: -80px;
  width: 280px; height: 280px; border-radius: 50%;
  background: radial-gradient(circle, rgba(255,122,48,.15) 0%, transparent 70%);
}
.hero::after {
  content: ''; position: absolute; bottom: -60px; left: -60px;
  width: 200px; height: 200px; border-radius: 50%;
  background: radial-gradient(circle, rgba(99,102,241,.12) 0%, transparent 70%);
}
.hero-inner { position: relative; z-index: 1; max-width: 600px; margin: 0 auto; }
.hero-title { font-size: 26px; font-weight: 800; color: #fff; margin-bottom: 6px; line-height: 1.25; }
.hero-sub { font-size: 14px; color: rgba(255,255,255,.5); margin-bottom: 20px; }
.hero-search {
  position: relative; max-width: 480px; margin: 0 auto;
}
.hero-search input {
  width: 100%; padding: 13px 20px 13px 44px;
  border-radius: 14px; border: none;
  font-size: 14px; color: var(--text-main);
  box-shadow: 0 4px 24px rgba(0,0,0,.2);
}
.hero-search .s-icon {
  position: absolute; left: 16px; top: 50%; transform: translateY(-50%);
  color: #9CA3AF; pointer-events: none;
}

/* CATEGORY CAROUSEL */
.cat-section {
  max-width: 1200px; margin: -22px auto 0; padding: 0 20px;
  position: relative; z-index: 10;
}
.cat-scroll {
  display: flex; gap: 10px; overflow-x: auto;
  padding: 14px 4px; scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}
.cat-scroll::-webkit-scrollbar { display: none; }
.cat-pill {
  flex-shrink: 0; padding: 8px 20px;
  border-radius: 99px; font-size: 13.5px; font-weight: 600;
  border: 1.5px solid var(--border); background: #fff;
  color: var(--text-muted); cursor: pointer;
  white-space: nowrap; transition: all .15s;
  user-select: none;
}
.cat-pill:hover { border-color: var(--primary); color: var(--primary); }
.cat-pill.active {
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; border-color: transparent;
  box-shadow: 0 2px 10px rgba(255,122,48,.3);
}

/* SHOP GRID */
.shop-section { max-width: 1200px; margin: 0 auto; padding: 24px 20px 60px; }
.section-head {
  display: flex; align-items: baseline; justify-content: space-between;
  margin-bottom: 20px;
}
.section-head .left {}
.section-title { font-size: 20px; font-weight: 800; color: var(--text-main); }
.section-sub { font-size: 13px; color: var(--text-muted); margin-top: 2px; }
.section-action {
  font-size: 13px; font-weight: 600; color: var(--primary);
  cursor: pointer; transition: opacity .15s;
}
.section-action:hover { opacity: .75; }

.shop-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 18px;
}
.shop-card {
  background: var(--bg-card); border-radius: 16px;
  border: 1px solid #f0f0f0;
  box-shadow: var(--shadow-sm);
  overflow: hidden; cursor: pointer;
  transition: transform .2s, box-shadow .2s;
}
.shop-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}
.shop-img {
  height: 140px; position: relative;
  background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
  display: flex; align-items: center; justify-content: center;
  overflow: hidden;
}
.shop-img img { width: 100%; height: 100%; object-fit: cover; }
.shop-img .fallback-icon { color: #9CA3AF; }
.shop-badge {
  position: absolute; top: 10px; right: 10px;
  background: #DCFCE7; color: #16A34A;
  font-size: 11px; font-weight: 700;
  padding: 3px 10px; border-radius: 99px;
  display: inline-flex; align-items: center; gap: 4px;
}
.shop-badge::before {
  content: ''; width: 6px; height: 6px; border-radius: 50%;
  background: #16A34A; display: inline-block;
}
.shop-body { padding: 14px 16px 16px; }
.shop-name {
  font-size: 15px; font-weight: 700; color: var(--text-main);
  line-height: 1.3; margin-bottom: 4px;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.shop-desc {
  font-size: 13px; color: #9CA3AF;
  display: -webkit-box; -webkit-line-clamp: 2;
  -webkit-box-orient: vertical; overflow: hidden;
  margin-bottom: 8px; min-height: 36px;
}
.shop-meta { display: flex; flex-direction: column; gap: 3px; margin-bottom: 12px; }
.shop-meta-row {
  display: flex; align-items: flex-start; gap: 6px;
  font-size: 12px; color: #9CA3AF;
}
.shop-meta-row svg { flex-shrink: 0; margin-top: 1px; }
.shop-meta-row span {
  overflow: hidden; text-overflow: ellipsis;
  white-space: nowrap;
}
.btn-shop {
  width: 100%; padding: 10px; border-radius: 10px;
  background: linear-gradient(135deg, var(--primary), #FF9A5C);
  color: #fff; font-size: 13.5px; font-weight: 600;
  text-align: center; border: none; cursor: pointer;
  transition: opacity .15s, transform .15s;
  box-shadow: 0 3px 12px rgba(255,122,48,.25);
}
.btn-shop:hover { opacity: .9; transform: translateY(-1px); }

/* EMPTY STATE */
.empty-state {
  text-align: center; padding: 64px 24px; color: #D1D5DB;
}
.empty-icon { margin-bottom: 12px; }
.empty-title { font-size: 16px; font-weight: 600; color: #9CA3AF; margin-bottom: 4px; }
.empty-hint { font-size: 13px; color: #D1D5DB; }

/* FOOTER */
.footer {
  text-align: center; padding: 24px;
  font-size: 12.5px; color: #C4C4C4;
  border-top: 1px solid #f0f0f0;
}

/* RESPONSIVE */
@media (max-width: 640px) {
  .nav-search { display: none; }
  .nav-links .hide-mobile { display: none; }
  .hero-title { font-size: 22px; }
  .hero-sub { font-size: 13px; }
  .shop-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
  .shop-img { height: 120px; }
  .shop-body { padding: 10px 12px 14px; }
  .shop-name { font-size: 13.5px; }
  .shop-desc { font-size: 11.5px; min-height: 30px; }
  .btn-shop { font-size: 12px; padding: 8px; }
  .cat-pill { font-size: 12.5px; padding: 7px 16px; }
}
</style>
>>>>>>> ThanhHien_TY00243
</head>
<body>
<div class="starfield"></div>

<<<<<<< HEAD
<!-- ═══════════════════ NAVBAR ═══════════════════ -->
<nav class="navbar">
    <div class="navbar-inner">
        <div class="logo">
            <div class="logo-mark">POB</div>
            <span class="logo-text">POB <span>Food</span></span>
        </div>

        <div class="search-wrap">
            <span class="s-icon">🔍</span>
            <input id="navSearch" type="text" placeholder="Tìm quán ăn, món ngon..."
                   oninput="filterShops(this.value)">
        </div>

        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">
                <span>📦</span><span>Đơn hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link">
                <span>📍</span><span>Địa chỉ</span>
            </a>

            <div class="avatar-wrap" id="avatarWrap">
                <button class="avatar-btn" onclick="toggleDropdown()" title="${account.fullName}">
                    <c:choose>
                        <c:when test="${not empty account.avatarUrl}">
                            <img src="${account.avatarUrl}" alt="avatar" style="width:100%;height:100%;object-fit:cover;">
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${not empty account.fullName}">${fn:substring(account.fullName,0,1)}</c:when>
                                <c:otherwise>${fn:substring(account.userName,0,1)}</c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </button>

                <div class="dropdown" id="accountDropdown">
                    <div class="dropdown-header">
                        <div class="d-name">
                            <c:choose>
                                <c:when test="${not empty account.fullName}">${account.fullName}</c:when>
                                <c:otherwise>${account.userName}</c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${not empty account.email}">
                            <div class="d-email">${account.email}</div>
                        </c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng của tôi</a>
                    <a href="${pageContext.request.contextPath}/user/dia-chi">📍 Địa chỉ giao hàng</a>
                    <a href="${pageContext.request.contextPath}/user/doi-mat-khau">🔒 Đổi mật khẩu</a>
                    <div class="d-divider"></div>
                    <form action="${pageContext.request.contextPath}/logout" method="post">
                        <button type="submit" class="d-logout">🚪 Đăng xuất</button>
                    </form>
                </div>
            </div>
=======
<!-- ===== NAVBAR ===== -->
<nav class="navbar">
  <div class="nav-logo">POB</div>
  <span class="nav-brand">POB Food</span>

  <div class="nav-search">
    <svg class="s-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
    <input id="navSearch" type="text" placeholder="Tìm quán, món ăn..." oninput="filterShops(this.value)">
  </div>

  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link hide-mobile">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m7.5 4.27 9 5.15"/><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/></svg>
      <span>Đơn hàng</span>
    </a>
    <a href="${pageContext.request.contextPath}/user/dia-chi" class="nav-link hide-mobile">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
      <span>Địa chỉ</span>
    </a>
    <div class="relative" id="avatarWrap" style="margin-left:4px;">
      <button class="avatar-btn" onclick="toggleDropdown()" aria-label="Tài khoản">${fn:substring(not empty account.fullName ? account.fullName : account.userName, 0, 1)}</button>
      <div class="dropdown" id="accountDropdown">
        <div class="dropdown-header">
          <div class="name">${not empty account.fullName ? account.fullName : account.userName}</div>
          <c:if test="${not empty account.email}"><div class="email">${account.email}</div></c:if>
>>>>>>> ThanhHien_TY00243
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
  </div>
</nav>

<<<<<<< HEAD
<!-- Search bar mobile -->
<div class="hero-search-bar">
    <div class="hs-wrap">
        <span class="hs-icon">🔍</span>
        <input id="mobileSearch" type="text" placeholder="Tìm quán ăn, món ngon..."
               oninput="filterShops(this.value)">
    </div>
</div>

<!-- ═══════════════════ BANNER SLIDER ═══════════════════ -->
<div class="banner-section">
    <div class="banner-wrap">
        <div class="slider" id="slider">
            <div class="slider-track" id="sliderTrack">
                <div class="slide slide-1">
                    <div class="slide-content">
                        <div class="slide-tag">🔥 Ưu đãi hôm nay</div>
                        <div class="slide-title">Giảm 30% cho<br>đơn đầu tiên!</div>
                        <div class="slide-sub">Áp dụng cho tất cả cửa hàng</div>
                        <button class="slide-btn">Khám phá ngay →</button>
                    </div>
                    <div class="slide-emoji">🍜</div>
                </div>
                <div class="slide slide-2">
                    <div class="slide-content">
                        <div class="slide-tag">⚡ Flash Sale</div>
                        <div class="slide-title">Freeship cho<br>đơn trên 50K!</div>
                        <div class="slide-sub">Giao hàng nhanh trong 30 phút</div>
                        <button class="slide-btn">Đặt ngay →</button>
                    </div>
                    <div class="slide-emoji">🛵</div>
                </div>
                <div class="slide slide-3">
                    <div class="slide-content">
                        <div class="slide-tag">🥗 Healthy</div>
                        <div class="slide-title">Ăn ngon – Sống<br>khỏe mỗi ngày!</div>
                        <div class="slide-sub">Hàng trăm món healthy tươi ngon</div>
                        <button class="slide-btn">Xem thực đơn →</button>
                    </div>
                    <div class="slide-emoji">🥗</div>
                </div>
                <div class="slide slide-4">
                    <div class="slide-content">
                        <div class="slide-tag">🎉 Cuối tuần vui</div>
                        <div class="slide-title">Combo gia đình<br>giảm đến 40%!</div>
                        <div class="slide-sub">Mua 2 tặng 1 – Thứ 7 &amp; Chủ nhật</div>
                        <button class="slide-btn">Xem ưu đãi →</button>
                    </div>
                    <div class="slide-emoji">🍕</div>
                </div>
            </div>
        </div>
    </div>
    <div class="slider-dots">
        <button class="dot active" onclick="goSlide(0)"></button>
        <button class="dot" onclick="goSlide(1)"></button>
        <button class="dot" onclick="goSlide(2)"></button>
        <button class="dot" onclick="goSlide(3)"></button>
    </div>
</div>

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
            </div>
        </div>
=======
<!-- ===== HERO ===== -->
<div class="hero">
  <div class="hero-inner">
    <h1 class="hero-title">🍽️ Tìm quán ăn ngon gần bạn</h1>
    <p class="hero-sub">Khám phá các quán ăn hấp dẫn, đặt đồ ăn dễ dàng</p>
    <div class="hero-search">
      <svg class="s-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
      <input id="heroSearch" type="text" placeholder="Tìm quán ăn, món ăn..." oninput="filterShops(this.value)">
>>>>>>> ThanhHien_TY00243
    </div>
  </div>
</div>

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
                <c:choose>
                    <c:when test="${empty shops}">0</c:when>
                    <c:otherwise>${shops.size()}</c:otherwise>
                </c:choose>
            </span>
        </div>
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
    </div>
    <span class="section-action" onclick="filterShops('')">Xem tất cả</span>
  </div>

<<<<<<< HEAD
    <c:choose>
        <c:when test="${empty shops}">
            <div class="empty-state">
                <div class="e-icon">🍽️</div>
                <div class="e-title">Chưa có cửa hàng nào mở cửa</div>
                <div class="e-sub">Vui lòng quay lại sau nhé!</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="shop-grid" id="shopGrid">
                <c:forEach var="shop" items="${shops}" varStatus="vs">
                    <div class="shop-card"
                         data-name="${fn:toLowerCase(shop.shopName)}"
                         data-desc="${fn:toLowerCase(shop.shopDescription)}"
                         data-addr="${fn:toLowerCase(shop.shopAddress)}"
                         onclick="goToShop(${shop.id})">

                        <div class="card-thumb">
                            <c:choose>
                                <c:when test="${not empty shop.shopLogo}">
                                    <img src="${shop.shopLogo}" alt="${shop.shopName}"
                                         onerror="this.style.display='none';this.nextSibling.style.display='flex'">
                                    <div class="thumb-fallback" style="display:none;width:100%;height:100%;align-items:center;justify-content:center;">🍽️</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="thumb-fallback">🍽️</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="thumb-overlay"></div>
                            <div class="badge-open">
                                <span class="pulse-dot"></span> Đang mở
                            </div>
                            <c:if test="${vs.index % 3 == 0}">
                                <div class="badge-promo">-20%</div>
                            </c:if>
                            <div class="card-rating">
                                <span class="stars">★★★★</span>
                                <span>${4 + (vs.index % 2) * 0}.${5 - (vs.index % 3)}</span>
                            </div>
                        </div>

                        <div class="card-body">
                            <div class="card-name">${shop.shopName}</div>
                            <c:if test="${not empty shop.shopDescription}">
                                <div class="card-desc">${shop.shopDescription}</div>
                            </c:if>
                            <div class="card-meta">
                                <c:if test="${not empty shop.shopAddress}">
                                    <span>📍 ${shop.shopAddress}</span>
                                </c:if>
                                <c:if test="${not empty shop.shopPhone}">
                                    <span class="meta-sep">·</span>
                                    <span>📞 ${shop.shopPhone}</span>
                                </c:if>
                            </div>
                        </div>

                        <div class="card-footer">
                            <div class="card-price">
                                Từ <strong>20.000đ</strong>
                                <br><small>⚡ Giao 30 phút</small>
                            </div>
                            <button class="btn-add" onclick="event.stopPropagation();goToShop(${shop.id})">
                                Xem thực đơn →
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="empty-state" style="display:none;">
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
                </c:when>
                <c:otherwise>
                  <svg class="fallback-icon" width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2"/><path d="M7 2v20"/><path d="M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7"/></svg>
                </c:otherwise>
              </c:choose>
              <span class="shop-badge">Đang mở</span>
            </div>

            <div class="shop-body">
              <div class="shop-name" title="${fn:escapeXml(shop.shopName)}">${fn:escapeXml(shop.shopName)}</div>
              <c:if test="${not empty shop.shopDescription}">
                <div class="shop-desc">${fn:escapeXml(shop.shopDescription)}</div>
              </c:if>
              <div class="shop-meta">
                <c:if test="${not empty shop.shopAddress}">
                  <div class="shop-meta-row">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                    <span>${fn:escapeXml(shop.shopAddress)}</span>
                  </div>
                </c:if>
                <c:if test="${not empty shop.shopPhone}">
                  <div class="shop-meta-row">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.362 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.338 1.85.573 2.81.7A2 2 0 0 1 22 16.92Z"/></svg>
                    <span>${fn:escapeXml(shop.shopPhone)}</span>
                  </div>
                </c:if>
              </div>
              <button class="btn-shop">Xem thực đơn &rarr;</button>
>>>>>>> ThanhHien_TY00243
            </div>

          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

  <div id="noResults" class="empty-state" style="display:none;">
    <div class="empty-icon">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
    </div>
    <div class="empty-title">Không tìm thấy quán nào</div>
    <div class="empty-hint">Thử từ khoá khác nhé</div>
  </div>
</div>

<<<<<<< HEAD
<!-- ═══════════════════ FOOTER ═══════════════════ -->
<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div class="footer-brand">
                <div class="logo-mark">POB</div>
                <div class="brand-name">POB Food</div>
                <p>Ứng dụng đặt đồ ăn nhanh chóng, tiện lợi – kết nối bạn với hàng trăm quán ăn ngon mỗi ngày.</p>
                <div class="footer-socials">
                    <a href="#" class="social-btn">📘</a>
                    <a href="#" class="social-btn">📸</a>
                    <a href="#" class="social-btn">🎵</a>
                    <a href="#" class="social-btn">▶️</a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Dịch vụ</h4>
                <a href="#">Đặt đồ ăn</a>
                <a href="#">Theo dõi đơn hàng</a>
                <a href="#">Ưu đãi</a>
                <a href="#">Hợp tác nhà hàng</a>
            </div>
            <div class="footer-col">
                <h4>Hỗ trợ</h4>
                <a href="#">Trung tâm trợ giúp</a>
                <a href="#">Chính sách hoàn tiền</a>
                <a href="#">Điều khoản sử dụng</a>
                <a href="#">Chính sách bảo mật</a>
            </div>
            <div class="footer-col">
                <h4>Liên hệ</h4>
                <a href="#">📞 1800 6789</a>
                <a href="#">✉️ support@pobfood.vn</a>
                <a href="#">🕐 08:00 – 22:00</a>
                <a href="#">📍 TP. Hồ Chí Minh</a>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2024 POB Food · Đặt đồ ăn dễ dàng &amp; nhanh chóng</span>
            <span>Được làm với ❤️ bởi nhóm POB</span>
        </div>
    </div>
</footer>
=======
<!-- ===== FOOTER ===== -->
<div class="footer">
  &copy; 2024 POB Food &nbsp;·&nbsp; Đặt đồ ăn dễ dàng
</div>
>>>>>>> ThanhHien_TY00243

<!-- ===== SCRIPTS ===== -->
<script>
function goToShop(shopId) {
  window.location.href = '${pageContext.request.contextPath}/user/shop?id=' + shopId;
}

function filterShops(query) {
  ['navSearch','heroSearch'].forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.value = query;
  });
  var q = query.toLowerCase().trim();
  var cards = document.querySelectorAll('#shopGrid .shop-card');
  if (!cards.length) return;
  var visible = 0;
  cards.forEach(function(card) {
    var name = card.dataset.name || '';
    var desc = card.dataset.desc || '';
    var addr = card.dataset.addr || '';
    var match = !q || name.includes(q) || desc.includes(q) || addr.includes(q);
    card.style.display = match ? '' : 'none';
    if (match) visible++;
  });
  var noRes = document.getElementById('noResults');
  var cnt = document.getElementById('shopCount');
  if (noRes) noRes.style.display = visible === 0 ? 'block' : 'none';
  if (cnt) {
    cnt.textContent = q
      ? visible + ' cửa hàng khớp với "' + query + '"'
      : visible + ' cửa hàng đang phục vụ';
  }
  // deactivate category pills on text search
  if (q) deactivateAllPills();
}

function filterCategory(catName, btn) {
  document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
  btn.classList.add('active');
  var cards = document.querySelectorAll('#shopGrid .shop-card');
  var visible = 0;
  cards.forEach(function(card) { card.style.display = ''; visible++; });
  var noRes = document.getElementById('noResults');
  var cnt = document.getElementById('shopCount');
  if (noRes) noRes.style.display = 'none';
  if (cnt) cnt.textContent = visible + ' cửa hàng đang phục vụ';
  // clear text search to avoid confusion
  ['navSearch','heroSearch'].forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.value = '';
  });
}

<<<<<<< HEAD
        var visible = 0;
        cards.forEach(function(card) {
            var match = !q
                || (card.dataset.name || '').includes(q)
                || (card.dataset.desc || '').includes(q)
                || (card.dataset.addr || '').includes(q);
            card.style.display = match ? '' : 'none';
            if (match) visible++;
        });

        var noResults = document.getElementById('noResults');
        var countEl   = document.getElementById('shopCount');
        if (noResults) noResults.style.display = (visible === 0) ? 'block' : 'none';
        if (countEl) countEl.textContent = visible;
    }

    /* ── Category filter (UI only — shops don't have category tags yet) ── */
    function filterCat(el, cat) {
        document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
        el.classList.add('active');
        // Reset search to show all
        if (cat === 'all') filterShops('');
    }

    /* ── Avatar dropdown ── */
    function toggleDropdown() {
        document.getElementById('accountDropdown').classList.toggle('open');
    }
    document.addEventListener('click', function(e) {
        var wrap = document.getElementById('avatarWrap');
        if (wrap && !wrap.contains(e.target))
            document.getElementById('accountDropdown').classList.remove('open');
    });

    /* ── Banner Slider ── */
    var currentSlide = 0;
    var totalSlides = 4;
    var autoSlideTimer;

    function goSlide(index) {
        currentSlide = index;
        document.getElementById('sliderTrack').style.transform = 'translateX(-' + (index * 100) + '%)';
        document.querySelectorAll('.dot').forEach(function(d, i) {
            d.classList.toggle('active', i === index);
        });
    }

    function nextSlide() {
        goSlide((currentSlide + 1) % totalSlides);
    }

    function startAutoSlide() {
        autoSlideTimer = setInterval(nextSlide, 4000);
    }

    var slider = document.getElementById('slider');
    slider.addEventListener('mouseenter', function() { clearInterval(autoSlideTimer); });
    slider.addEventListener('mouseleave', startAutoSlide);

    /* Swipe support */
    var touchStartX = 0;
    slider.addEventListener('touchstart', function(e) { touchStartX = e.touches[0].clientX; }, {passive:true});
    slider.addEventListener('touchend', function(e) {
        var dx = e.changedTouches[0].clientX - touchStartX;
        if (Math.abs(dx) > 40) goSlide(dx < 0 ? (currentSlide + 1) % totalSlides : (currentSlide - 1 + totalSlides) % totalSlides);
    }, {passive:true});

    startAutoSlide();
=======
function deactivateAllPills() {
  document.querySelectorAll('.cat-pill').forEach(function(p) { p.classList.remove('active'); });
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
>>>>>>> ThanhHien_TY00243
</script>
</body>
</html>

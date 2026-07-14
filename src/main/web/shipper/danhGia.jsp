<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <script>!function(){var t=localStorage.getItem("shipper-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá & Báo cáo - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-card: #1e293b; --bg-input: #0f172a;
            --text-main: #f8fafc; --text-muted: #94a3b8; --border-color: #334155;
            --topbar-bg: rgba(30,41,59,0.8); --shadow: 0 4px 6px -1px rgb(0 0 0/0.2);
        }
        :root[data-theme="light"] {
            --bg-base: #f4f7f5; --bg-card: #ffffff; --bg-input: #f8fafc;
            --text-main: #1e293b; --text-muted: #64748b; --border-color: #e2e8f0;
            --topbar-bg: rgba(255,255,255,0.85); --shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        :root {
            --primary: #4CAF50; --primary-hover: #43a047; --primary-light: rgba(76,175,80,0.12);
            --secondary: #FF9800; --secondary-hover: #f57c00; --secondary-light: rgba(255,152,0,0.12);
            --danger: #ef4444;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.25s, border-color 0.25s; }
        body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-card); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(76,175,80,0.3); }
        .brand-title { font-weight: 700; font-size: 16px; letter-spacing: 0.5px; }
        .menu { padding: 20px 12px; flex: 1; }
        .menu-item { padding: 14px 16px; display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 14px; font-weight: 600; border-radius: 8px; margin-bottom: 6px; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); }

        /* ONLINE TOGGLE */
        .online-toggle-wrap { padding: 16px 12px; border-top: 1px solid var(--border-color); }
        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: 10px; border: none; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; transition: all 0.2s; }
        .online-toggle-btn.is-online { background: var(--primary-light); color: var(--primary); border: 1.5px solid var(--primary); }
        .online-toggle-btn.is-offline { background: rgba(239,68,68,0.08); color: #ef4444; border: 1.5px solid rgba(239,68,68,0.3); }
        .online-toggle-btn:hover { opacity: 0.85; }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--primary); box-shadow: 0 0 0 3px rgba(76,175,80,0.25); animation: pulse-green 1.5s infinite; }
        .toggle-dot.offline { background: #ef4444; }
        @keyframes pulse-green { 0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,0.25);}50%{box-shadow:0 0 0 6px rgba(76,175,80,0.1);} }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { font-size: 18px; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .avatar-circle { background: var(--primary); color: white; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .btn-logout { padding: 8px 16px; border-radius: 8px; background: rgba(239,68,68,0.1); color: var(--danger); font-size: 13px; font-weight: 600; }
        .btn-logout:hover { background: var(--danger); color: white; }
        .online-badge { display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .online-badge.online { background: var(--primary-light); color: var(--primary); }
        .online-badge.offline { background: rgba(239,68,68,0.1); color: #ef4444; }

        /* CONTENT */
        .content { padding: 24px 32px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 20px; animation: fadeIn 0.3s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

        /* ORDER CARDS */
        .order-list { display: flex; flex-direction: column; gap: 14px; }
        .order-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; box-shadow: var(--shadow); position: relative; overflow: hidden; }
        .order-card::before { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: #94a3b8; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        .order-id { font-weight: 700; font-size: 15px; }
        .order-time { font-size: 12px; color: var(--text-muted); }
        .shop-name { font-size: 13px; color: var(--text-muted); margin-top: 2px; }
        .route-timeline { padding-left: 20px; margin-bottom: 14px; }
        .route-step { margin-bottom: 10px; font-size: 13px; }
        .route-step:last-child { margin-bottom: 0; }
        .route-label { font-size: 11px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; }
        .route-text { font-weight: 600; margin-top: 2px; }
        .price-tag { font-size: 15px; font-weight: 700; color: var(--primary); }
        .badge-done { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 99px; font-size: 11px; font-weight: 700; background: rgba(34,197,94,0.1); color: #16a34a; }
        .btn-flex-group { display: flex; gap: 8px; justify-content: flex-end; align-items: center; margin-top: 14px; flex-wrap: wrap; }
        .btn-action { padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 700; border: none; cursor: pointer; }
        .btn-action-outline { background: transparent; border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-action-outline:hover { background: var(--bg-input); }
        .btn-feedback { background: #fffbeb; color: #d97706; border: 1px solid #fcd34d; padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-feedback:hover { opacity: .85; }
        .btn-bom { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-bom:hover { opacity: .85; }
        .btn-disabled { background: var(--bg-input); color: var(--text-muted); border: 1px solid var(--border-color); padding: 10px 18px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: default; }

        /* EMPTY */
        .empty-box { text-align: center; padding: 60px 24px; color: var(--text-muted); background: var(--bg-card); border-radius: 14px; border: 1px dashed var(--border-color); }

        /* ALERT */
        .alert-success { background: #f0fdf4; border: 1px solid #86efac; color: #166534; border-radius: 10px; padding: 12px 16px; font-size: 14px; font-weight: 500; }

        /* Mobile */
        @media (max-width: 768px) {
            body { flex-direction: column; }
            .sidebar { width: 100%; height: auto; border-right: none; border-bottom: 1px solid var(--border-color); }
            .menu { display: flex; overflow-x: auto; padding: 10px; }
            .menu-item { margin-bottom: 0; white-space: nowrap; }
            .topbar { padding: 12px 16px; }
            .content { padding: 16px; }
        }
            .avatar-btn { background: var(--primary); color: #fff; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; cursor: pointer; border: 2px solid transparent; transition: all 0.2s; user-select: none; overflow: hidden; }
        .avatar-btn:hover { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16,185,129,0.2); }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-card, #1e293b); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 12px 32px rgba(0,0,0,0.3); min-width: 220px; z-index: 9999; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-primary, #f8fafc); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-secondary, #94a3b8); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: rgba(16,185,129,0.15); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-secondary, #94a3b8); transition: background 0.15s; text-decoration: none; }
        .dropdown-link:hover { background: rgba(255,255,255,0.05); color: var(--text-primary, #f8fafc); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger, #ef4444); }
        .dropdown-link.danger:hover { background: rgba(239,68,68,0.1); }</style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="logo">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <div style="font-size:10px; color:var(--primary); font-weight:bold;">● ĐANG HOẠT ĐỘNG</div>
                </c:when>
                <c:otherwise>
                    <div style="font-size:10px; color:#ef4444; font-weight:bold;">● NGOẠI TUYẾN</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/shipper/donhang">
            <li class="menu-item"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don">
            <li class="menu-item"><span>📥 Nhận đơn mới</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard">
            <li class="menu-item"><span>📊 Dashboard</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao">
            <li class="menu-item"><span>🔔 Thông báo</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/profile">
            <li class="menu-item"><span>👤 Hồ sơ tài xế</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia">
            <li class="menu-item active"><span>⭐ Đánh giá & Báo cáo</span></li>
        </a>
    </ul>
    <div class="online-toggle-wrap">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>
                        Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>
                        Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <h1>
            ⭐ Đánh giá & Báo cáo
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <span class="online-badge online">● Online</span>
                </c:when>
                <c:otherwise>
                    <span class="online-badge offline">● Offline</span>
                </c:otherwise>
            </c:choose>
        </h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-btn" id="avatarBtn"><c:choose><c:when test="${not empty sessionScope.account.avatarUrl}"><img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/></c:when><c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise></c:choose></div>
        </div>
    </header>

    <div class="content">

        <c:if test="${param.success eq '1'}">
            <div class="alert-success">✅ Đánh giá của bạn đã được gửi thành công!</div>
        </c:if>

        <c:choose>
            <c:when test="${empty doneOrders}">
                <div class="empty-box">
                    <div style="font-size:48px; margin-bottom:12px;">📭</div>
                    <p style="font-size:15px; font-weight:600; margin-bottom:6px;">Chưa có đơn hàng hoàn thành</p>
                    <p style="font-size:13px;">Sau khi giao xong đơn hàng, bạn có thể đánh giá shop và báo cáo tại đây.</p>
                </div>
            </c:when>
            <c:otherwise>
                <p style="font-size:13px; color:var(--text-muted);">
                    Tổng <strong>${doneOrders.size()}</strong> đơn đã hoàn thành
                </p>

                <div class="order-list">
                    <c:forEach var="order" items="${doneOrders}">
                        <div class="order-card">
                            <div class="order-header">
                                <div>
                                    <div class="order-id">Đơn #${order.id}</div>
                                    <div class="shop-name">🏪 ${shopNames[order.shopId]}</div>
                                </div>
                                <span class="badge-done">✓ Hoàn thành</span>
                            </div>

                            <div class="route-timeline">
                                <div class="route-step">
                                    <div class="route-label">Địa chỉ giao</div>
                                    <div class="route-text">📍 ${order.shippingAddress}</div>
                                </div>
                                <div class="route-step">
                                    <div class="route-label">Người nhận</div>
                                    <div class="route-text">👤 ${order.receiverName} — ${order.receiverPhone}</div>
                                </div>
                            </div>

                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
                                <span class="price-tag">
                                    💰 <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/>đ
                                </span>
                            </div>

                            <div class="btn-flex-group">
                                <c:choose>
                                    <c:when test="${feedbackShop[order.id]}">
                                        <span class="btn-disabled">✓ Đã đánh giá shop</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/shipper/feedback?orderId=${order.id}">
                                            <button class="btn-feedback">⭐ Đánh giá Shop</button>
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <form action="${pageContext.request.contextPath}/shipper/bom-hang" method="post" style="display:inline;"
                                      onsubmit="return confirm('Xác nhận báo cáo khách hàng này đã bom hàng?')">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn-bom">🚫 Báo bom hàng</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<script>
    const btn = document.getElementById('themeToggleBtn');
    const root = document.documentElement;
    const saved = localStorage.getItem('shipper-theme') || 'light';
    root.setAttribute('data-theme', saved);
    btn.addEventListener('click', () => {
        const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', next);
        localStorage.setItem('shipper-theme', next);
    });
</script>


<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🛵 Shipper</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shipper/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shipper/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var avatarBtn = document.getElementById('avatarBtn');
    var avatarDropdown = document.getElementById('avatarDropdown');
    if (avatarBtn && avatarDropdown) {
        avatarBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            var rect = avatarBtn.getBoundingClientRect();
            avatarDropdown.style.top = (rect.bottom + 10) + 'px';
            avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
            avatarDropdown.classList.toggle('open');
        });
        avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
        document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
    }
});
</script></body>
</html>

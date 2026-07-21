<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Chi tiết đơn hàng #${order.id} - POB Shipper</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .avatar-wrapper { position: relative; }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--dash-shadow-md); min-width: 220px; z-index: 500; }
        .avatar-dropdown.open { display: block; animation: pobFadeUp .18s ease both; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-header .d-role { display: inline-block; margin-top: 6px; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }
        .dropdown-link.danger:hover { background: var(--danger-light); color: var(--danger); }

        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: var(--radius-sm); border: none; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; }
        .online-toggle-btn.is-online { background: var(--success-light); color: var(--success-dark); border: 1.5px solid var(--success); }
        .online-toggle-btn.is-offline { background: var(--danger-light); color: var(--danger); border: 1.5px solid var(--danger); }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--success); animation: pobBlink 1.5s infinite; }
        .toggle-dot.offline { background: var(--danger); }

        /* Route timeline */
        .route-timeline { display: flex; flex-direction: column; gap: 0; }
        .route-point { display: flex; gap: 14px; padding: 14px 0; }
        .route-point:not(:last-child) { border-bottom: 1px dashed var(--border-color); }
        .route-dot { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 16px; flex-shrink: 0; }
        .dot-shop { background: var(--warning-light); color: var(--warning-dark); }
        .dot-customer { background: var(--primary-light); color: var(--primary); }
        .route-info-label { font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-dim); margin-bottom: 2px; }
        .route-info-name { font-weight: 700; font-size: 14px; color: var(--text-main); }
        .route-info-sub { font-size: 12px; color: var(--text-dim); margin-top: 2px; }

        /* Item checklist */
        .item-list { display: flex; flex-direction: column; gap: 10px; }
        .item-row { background: var(--bg-input); border-radius: var(--radius-sm); padding: 14px; cursor: pointer; transition: all .2s; }
        .item-name { font-weight: 700; font-size: 14px; color: var(--text-main); }
        .item-size { font-size: 12px; color: var(--text-dim); margin-top: 2px; }
        .item-topping-list { margin-top: 6px; padding-left: 12px; border-left: 2px solid var(--border-color); }
        .item-topping { font-size: 12px; color: var(--text-dim); padding: 2px 0; }
        .item-price-row { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; }
        .item-qty { font-size: 13px; color: var(--text-dim); }
        .item-subtotal { font-weight: 700; color: var(--primary); }
        .custom-check { width: 22px; height: 22px; border-radius: 6px; border: 2px solid var(--border-color); display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-top: 2px; transition: all .2s; background: var(--bg-panel); }

        .total-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; font-size: 15px; font-weight: 700; border-top: 2px solid var(--border-color); margin-top: 8px; color: var(--text-main); }
        .total-amount { font-size: 20px; font-weight: 800; color: var(--primary); }

        .badge-done { background: var(--success-light); color: var(--success-dark); }

        .action-bar { display: flex; gap: 10px; justify-content: flex-end; flex-wrap: wrap; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <span class="brand-subtitle" style="color:var(--success);">● Đang hoạt động</span>
                </c:when>
                <c:otherwise>
                    <span class="brand-subtitle" style="color:var(--danger);">● Ngoại tuyến</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="menu">
        <div class="menu-title">Công việc</div>
        <a href="${pageContext.request.contextPath}/shipper/donhang" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">📋</span> Đơn hàng nhận</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📥</span> Nhận đơn mới</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/dashboard" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span> Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🔔</span> Thông báo</span>
        </a>

        <div class="menu-title">Tài khoản</div>
        <a href="${pageContext.request.contextPath}/shipper/profile" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🚙</span> Hồ sơ tài xế</span>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span> Đánh giá &amp; Báo cáo</span>
        </a>
    </div>
    <div class="sidebar-foot">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>📦 Chi tiết đơn hàng #${order.id}</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
            <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-circle" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" alt="avatar"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <div class="content">

        <div class="panel">
            <div class="panel-header"><div class="panel-title">🗺️ Lộ trình giao hàng</div></div>
            <div class="panel-body">
                <div class="route-timeline">
                    <div class="route-point">
                        <div class="route-dot dot-shop">🏪</div>
                        <div>
                            <div class="route-info-label">Lấy hàng tại cửa hàng</div>
                            <div class="route-info-name">${bill.shopName}</div>
                            <c:if test="${not empty order.shopId}">
                                <div class="route-info-sub">Shop ID: ${order.shopId}</div>
                            </c:if>
                        </div>
                    </div>
                    <div class="route-point">
                        <div class="route-dot dot-customer">🏠</div>
                        <div>
                            <div class="route-info-label">Giao tới khách hàng</div>
                            <div class="route-info-name">${order.receiverName}</div>
                            <div class="route-info-sub">📍 ${order.shippingAddress}</div>
                            <div class="route-info-sub">📞 ${order.receiverPhone}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">✅ Kiểm tra món hàng tại quán</div>
                <div style="display:flex; align-items:center; gap:10px;">
                    <span id="checkProgress" style="font-size:12px; font-weight:700; color:var(--text-dim);">0/0</span>
                    <button onclick="resetChecklist()" title="Đặt lại" class="btn btn-ghost btn-sm">↺ Reset</button>
                </div>
            </div>
            <div class="panel-body">
                <div style="height:6px; background:var(--border-color); border-radius:99px; margin-bottom:16px; overflow:hidden;">
                    <div id="progressBar" style="height:100%; width:0%; background:var(--primary); border-radius:99px; transition:width .3s;"></div>
                </div>

                <div id="allCheckedBanner" class="alert alert-success" style="display:none; margin-bottom:14px; justify-content:center;">
                    🎉 Đã kiểm tra đủ tất cả món — sẵn sàng giao hàng!
                </div>

                <div class="item-list" id="checklistItems">
                    <c:forEach var="line" items="${bill.lines}" varStatus="vs">
                        <div class="item-row checklist-item" id="item-${vs.index}" onclick="toggleCheck(${vs.index})">
                            <div style="display:flex; align-items:flex-start; gap:12px;">
                                <div class="custom-check" id="check-${vs.index}"></div>
                                <div style="flex:1;">
                                    <div class="item-name" id="name-${vs.index}">${line.productName}</div>
                                    <div class="item-size">Size: ${line.sizeName}</div>
                                    <c:if test="${not empty line.toppings}">
                                        <div class="item-topping-list">
                                            <c:forEach var="tp" items="${line.toppings}">
                                                <div class="item-topping">
                                                    + ${tp.toppingName}
                                                    <c:if test="${tp.quantity > 1}"> × ${tp.quantity}</c:if>
                                                    (<fmt:formatNumber value="${tp.price}" type="number" maxFractionDigits="0"/>đ)
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                    <div class="item-price-row">
                                        <span class="item-qty">SL: ${line.quantity} × <fmt:formatNumber value="${line.price}" type="number" maxFractionDigits="0"/>đ</span>
                                        <span class="item-subtotal"><fmt:formatNumber value="${line.lineTotal}" type="number" maxFractionDigits="0"/>đ</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty bill.lines}">
                        <div style="text-align:center;padding:20px;color:var(--text-dim);">Không có dữ liệu chi tiết món hàng.</div>
                    </c:if>

                    <div class="total-row">
                        <span>Tổng cộng</span>
                        <span class="total-amount"><fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>đ</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header"><div class="panel-title">💳 Thông tin thanh toán</div></div>
            <div class="panel-body">
                <div class="info-row">
                    <span class="info-label">Trạng thái đơn</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.staTus == 'READY_FOR_PICKUP'}"><span class="badge badge-warning">📦 Chờ lấy hàng</span></c:when>
                            <c:when test="${order.staTus == 'SHIPPING'}"><span class="badge badge-primary">🛵 Đang giao</span></c:when>
                            <c:when test="${order.staTus == 'DONE'}"><span class="badge badge-done">✅ Đã giao</span></c:when>
                            <c:when test="${order.staTus == 'CANCELLED'}"><span class="badge badge-danger">🚫 Đã huỷ (bom hàng)</span></c:when>
                            <c:otherwise><span class="badge badge-neutral">${order.staTus}</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Hình thức TT</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'PAYOS'}">🏦 PayOS</c:when>
                            <c:when test="${order.paymentMethod == 'BANK'}">📱 QR Chuyển khoản</c:when>
                            <c:otherwise>💵 Tiền mặt (COD)</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Thời gian đặt</span>
                    <span class="info-value">${order.createdAt}</span>
                </div>
            </div>
        </div>

        <div class="action-bar">
            <a href="${pageContext.request.contextPath}/shipper/donhang">
                <button class="btn btn-ghost">← Quay lại danh sách</button>
            </a>

            <c:if test="${order.staTus == 'READY_FOR_PICKUP'}">
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToShipping">
                    <button type="submit" class="btn btn-warning">📦 Xác nhận đã lấy hàng</button>
                </form>
            </c:if>
            <c:if test="${order.staTus == 'SHIPPING'}">
                <form action="${pageContext.request.contextPath}/shipper/bom-hang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <button type="submit" class="btn btn-danger"
                            onclick="return confirm('Xác nhận user từ chối nhận hàng (bom hàng)? Hành vi này sẽ được ghi nhận.')">
                        🚫 Báo bom hàng
                    </button>
                </form>
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToDone">
                    <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận đơn hàng đã giao thành công?')">
                        🎉 Hoàn thành giao đơn
                    </button>
                </form>
            </c:if>
        </div>

    </div>
</main>

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

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    // --- CHECKLIST ---
    var ORDER_ID    = '${order.id}';
    var STORAGE_KEY = 'checklist_order_' + ORDER_ID;
    var total       = document.querySelectorAll('.checklist-item').length;

    function loadState() {
        try { return JSON.parse(localStorage.getItem(STORAGE_KEY)) || []; }
        catch (e) { return []; }
    }

    function saveState(checked) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(checked));
    }

    function updateUI(checked) {
        var count = checked.length;
        document.getElementById('checkProgress').textContent = count + '/' + total;
        document.getElementById('progressBar').style.width   = total > 0 ? (count / total * 100) + '%' : '0%';
        document.getElementById('allCheckedBanner').style.display = (count === total && total > 0) ? 'flex' : 'none';

        for (var i = 0; i < total; i++) {
            var isChecked = checked.indexOf(i) !== -1;
            var row  = document.getElementById('item-' + i);
            var box  = document.getElementById('check-' + i);
            var name = document.getElementById('name-' + i);

            if (isChecked) {
                box.style.background = 'var(--primary)';
                box.style.borderColor = 'var(--primary)';
                box.innerHTML = '<span style="color:#fff;font-size:13px;font-weight:900;">✓</span>';
                row.style.opacity = '0.6';
                name.style.textDecoration = 'line-through';
            } else {
                box.style.background = 'var(--bg-panel)';
                box.style.borderColor = 'var(--border-color)';
                box.innerHTML = '';
                row.style.opacity = '1';
                name.style.textDecoration = 'none';
            }
        }
    }

    function toggleCheck(index) {
        var checked = loadState();
        var pos = checked.indexOf(index);
        if (pos === -1) checked.push(index);
        else checked.splice(pos, 1);
        saveState(checked);
        updateUI(checked);
    }

    function resetChecklist() {
        if (!confirm('Đặt lại toàn bộ checklist?')) return;
        localStorage.removeItem(STORAGE_KEY);
        updateUI([]);
    }

    document.addEventListener('DOMContentLoaded', function () { updateUI(loadState()); });

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
</script>
</body>
</html>

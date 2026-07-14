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
    <title>Chi tiết đơn hàng #${order.id} - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base:#0f172a;--bg-card:#1e293b;--bg-input:#0f172a;
            --text-main:#f8fafc;--text-muted:#94a3b8;--border-color:#334155;
            --topbar-bg:rgba(30,41,59,0.8);--shadow:0 4px 6px -1px rgb(0 0 0/.2);
        }
        :root[data-theme="light"] {
            --bg-base:#f4f7f5;--bg-card:#ffffff;--bg-input:#f8fafc;
            --text-main:#1e293b;--text-muted:#64748b;--border-color:#e2e8f0;
            --topbar-bg:rgba(255,255,255,0.85);--shadow:0 4px 12px rgba(0,0,0,.03);
        }
        :root {
            --primary:#4CAF50;--primary-hover:#43a047;--primary-light:rgba(76,175,80,.12);
            --secondary:#FF9800;--secondary-hover:#f57c00;--secondary-light:rgba(255,152,0,.12);
            --danger:#ef4444;--font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        *{box-sizing:border-box;margin:0;padding:0;font-family:var(--font-family);transition:background-color .25s,border-color .25s}
        body{background-color:var(--bg-base);color:var(--text-main);display:flex;height:100vh;overflow:hidden}
        a{text-decoration:none;color:inherit}
        .sidebar{width:260px;background-color:var(--bg-card);border-right:1px solid var(--border-color);display:flex;flex-direction:column;flex-shrink:0;z-index:10}
        .brand{padding:24px;display:flex;align-items:center;gap:12px;border-bottom:1px solid var(--border-color)}
        .logo{background:linear-gradient(135deg,var(--primary),#2e7d32);color:#fff;width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px}
        .brand-title{font-weight:700;font-size:16px;letter-spacing:.5px}
        .menu{padding:20px 12px;flex:1}
        .menu-item{padding:14px 16px;display:flex;align-items:center;gap:12px;color:var(--text-muted);font-size:14px;font-weight:600;border-radius:8px;margin-bottom:6px}
        .menu-item:hover{background-color:var(--bg-input);color:var(--text-main);transform:translateX(4px)}
        .menu-item.active{background-color:var(--primary-light);color:var(--primary)}
        .online-toggle-wrap{padding:16px 12px;border-top:1px solid var(--border-color)}
        .online-toggle-btn{width:100%;padding:12px 16px;border-radius:10px;border:none;cursor:pointer;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:700;transition:all .2s}
        .online-toggle-btn.is-online{background:var(--primary-light);color:var(--primary);border:1.5px solid var(--primary)}
        .online-toggle-btn.is-offline{background:rgba(239,68,68,.08);color:#ef4444;border:1.5px solid rgba(239,68,68,.3)}
        .toggle-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
        .toggle-dot.online{background:var(--primary);animation:pulse-green 1.5s infinite}
        .toggle-dot.offline{background:#ef4444}
        @keyframes pulse-green{0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,.25)}50%{box-shadow:0 0 0 6px rgba(76,175,80,.1)}}
        .main{flex:1;display:flex;flex-direction:column;overflow:hidden}
        .topbar{background-color:var(--topbar-bg);backdrop-filter:blur(10px);padding:16px 32px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border-color)}
        .topbar h1{font-size:18px;font-weight:700;display:flex;align-items:center;gap:8px}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .theme-toggle{background:var(--bg-input);border:1px solid var(--border-color);width:38px;height:38px;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px}
        .avatar-circle{background:var(--primary);color:white;width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700}
        .btn-logout{padding:8px 16px;border-radius:8px;background:rgba(239,68,68,.1);color:var(--danger);font-size:13px;font-weight:600}
        .btn-logout:hover{background:var(--danger);color:white}
        .content{padding:24px 32px;overflow-y:auto;flex:1;display:flex;flex-direction:column;gap:20px;animation:fadeIn .3s ease-out}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:20px;box-shadow:var(--shadow)}
        .card-title{font-size:14px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border-color)}
        .info-row{display:flex;justify-content:space-between;align-items:flex-start;padding:8px 0;border-bottom:1px dashed var(--border-color);font-size:14px}
        .info-row:last-child{border-bottom:none}
        .info-label{color:var(--text-muted);font-weight:600;font-size:12px;text-transform:uppercase;min-width:140px}
        .info-value{font-weight:600;text-align:right}
        /* Route timeline */
        .route-timeline{display:flex;flex-direction:column;gap:0}
        .route-point{display:flex;gap:14px;padding:14px 0}
        .route-point:not(:last-child){border-bottom:1px dashed var(--border-color)}
        .route-dot{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
        .dot-shop{background:var(--secondary-light);color:var(--secondary)}
        .dot-customer{background:var(--primary-light);color:var(--primary)}
        .route-info-label{font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text-muted);margin-bottom:2px}
        .route-info-name{font-weight:700;font-size:14px}
        .route-info-sub{font-size:12px;color:var(--text-muted);margin-top:2px}
        /* Item table */
        .item-list{display:flex;flex-direction:column;gap:10px}
        .item-row{background:var(--bg-input);border-radius:10px;padding:14px}
        .item-name{font-weight:700;font-size:14px}
        .item-size{font-size:12px;color:var(--text-muted);margin-top:2px}
        .item-topping-list{margin-top:6px;padding-left:12px;border-left:2px solid var(--border-color)}
        .item-topping{font-size:12px;color:var(--text-muted);padding:2px 0}
        .item-price-row{display:flex;justify-content:space-between;align-items:center;margin-top:8px}
        .item-qty{font-size:13px;color:var(--text-muted)}
        .item-subtotal{font-weight:700;color:var(--primary)}
        /* Tổng tiền */
        .total-row{display:flex;justify-content:space-between;align-items:center;padding:12px 0;font-size:15px;font-weight:700;border-top:2px solid var(--border-color);margin-top:8px}
        .total-amount{font-size:20px;font-weight:800;color:var(--primary)}
        /* Badge */
        .badge{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:700;text-transform:uppercase}
        .badge-pickup{background:var(--secondary-light);color:var(--secondary)}
        .badge-shipping{background:var(--primary-light);color:var(--primary)}
        .badge-done{background:rgba(34,197,94,.1);color:#16a34a}
        /* Nút hành động */
        .action-bar{display:flex;gap:10px;justify-content:flex-end}
        .btn-back{padding:10px 20px;border-radius:8px;border:1px solid var(--border-color);background:transparent;color:var(--text-main);font-weight:700;font-size:13px;cursor:pointer}
        .btn-back:hover{background:var(--bg-input)}
        .btn-primary{padding:10px 20px;border-radius:8px;border:none;background:var(--primary);color:white;font-weight:700;font-size:13px;cursor:pointer}
        .btn-primary:hover{background:var(--primary-hover)}
        .btn-warning{padding:10px 20px;border-radius:8px;border:none;background:var(--secondary);color:white;font-weight:700;font-size:13px;cursor:pointer}
        .btn-warning:hover{background:var(--secondary-hover)}
        .btn-danger{padding:10px 20px;border-radius:8px;border:none;background:var(--danger);color:white;font-weight:700;font-size:13px;cursor:pointer}
        .btn-danger:hover{background:#dc2626}
        @media(max-width:768px){
            body{flex-direction:column}
            .sidebar{width:100%;height:auto;border-right:none;border-bottom:1px solid var(--border-color)}
            .menu{display:flex;overflow-x:auto;padding:10px}
            .menu-item{margin-bottom:0;white-space:nowrap}
            .content{padding:16px}
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
                    <div style="font-size:10px;color:var(--primary);font-weight:bold;">● ĐANG HOẠT ĐỘNG</div>
                </c:when>
                <c:otherwise>
                    <div style="font-size:10px;color:#ef4444;font-weight:bold;">● NGOẠI TUYẾN</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/shipper/donhang">
            <li class="menu-item active"><span>📋 Đơn hàng nhận</span></li>
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
            <li class="menu-item"><span>⭐ Đánh giá & Báo cáo</span></li>
        </a>
    </ul>
    <div class="online-toggle-wrap">
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
        <h1>📦 Chi tiết đơn hàng #${order.id}</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn" onclick="(function(){var t=document.documentElement.getAttribute('data-theme')==='dark'?'light':'dark';document.documentElement.setAttribute('data-theme',t);localStorage.setItem('shipper-theme',t)})()">🌓</button>
            <div class="avatar-btn" id="avatarBtn"><c:choose><c:when test="${not empty sessionScope.account.avatarUrl}"><img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/></c:when><c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise></c:choose></div>
        </div>
    </header>

    <div class="content">

        <%-- Lộ trình giao hàng --%>
        <div class="card">
            <div class="card-title">🗺️ Lộ trình giao hàng</div>
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

        <%-- Checklist món hàng --%>
        <div class="card">
            <%-- Header: tiêu đề + progress --%>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px; padding-bottom:10px; border-bottom:1px solid var(--border-color);">
                <div class="card-title" style="margin-bottom:0; padding-bottom:0; border-bottom:none;">
                    ✅ Kiểm tra món hàng tại quán
                </div>
                <div style="display:flex; align-items:center; gap:10px;">
                    <span id="checkProgress" style="font-size:12px; font-weight:700; color:var(--text-muted);">0/0</span>
                    <button onclick="resetChecklist()" title="Đặt lại"
                            style="background:transparent; border:1px solid var(--border-color); border-radius:6px;
                                   padding:4px 8px; font-size:11px; font-weight:700; color:var(--text-muted); cursor:pointer;">
                        ↺ Reset
                    </button>
                </div>
            </div>

            <%-- Progress bar --%>
            <div style="height:6px; background:var(--border-color); border-radius:99px; margin-bottom:16px; overflow:hidden;">
                <div id="progressBar" style="height:100%; width:0%; background:var(--primary); border-radius:99px; transition:width .3s;"></div>
            </div>

            <%-- Banner hoàn thành --%>
            <div id="allCheckedBanner" style="display:none; background:var(--primary-light); border:1px solid var(--primary);
                 color:var(--primary); border-radius:10px; padding:10px 14px; font-size:13px; font-weight:700;
                 margin-bottom:14px; text-align:center;">
                🎉 Đã kiểm tra đủ tất cả món — sẵn sàng giao hàng!
            </div>

            <div class="item-list" id="checklistItems">
                <c:forEach var="line" items="${bill.lines}" varStatus="vs">
                    <div class="item-row checklist-item" id="item-${vs.index}"
                         onclick="toggleCheck(${vs.index})"
                         style="cursor:pointer; transition:all .2s;">
                        <div style="display:flex; align-items:flex-start; gap:12px;">
                            <%-- Checkbox tùy chỉnh --%>
                            <div class="custom-check" id="check-${vs.index}"
                                 style="width:22px; height:22px; border-radius:6px; border:2px solid var(--border-color);
                                        display:flex; align-items:center; justify-content:center;
                                        flex-shrink:0; margin-top:2px; transition:all .2s; background:var(--bg-input);">
                            </div>
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
                                    <span class="item-qty">SL: ${line.quantity} ×
                                        <fmt:formatNumber value="${line.price}" type="number" maxFractionDigits="0"/>đ</span>
                                    <span class="item-subtotal">
                                        <fmt:formatNumber value="${line.lineTotal}" type="number" maxFractionDigits="0"/>đ
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty bill.lines}">
                    <div style="text-align:center;padding:20px;color:var(--text-muted);">
                        Không có dữ liệu chi tiết món hàng.
                    </div>
                </c:if>

                <div class="total-row">
                    <span>Tổng cộng</span>
                    <span class="total-amount">
                        <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>đ
                    </span>
                </div>
            </div>
        </div>

        <%-- Thông tin thanh toán & trạng thái --%>
        <div class="card">
            <div class="card-title">💳 Thông tin thanh toán</div>
            <div class="info-row">
                <span class="info-label">Trạng thái đơn</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${order.staTus == 'READY_FOR_PICKUP'}">
                            <span class="badge badge-pickup">📦 Chờ lấy hàng</span>
                        </c:when>
                        <c:when test="${order.staTus == 'SHIPPING'}">
                            <span class="badge badge-shipping">🛵 Đang giao</span>
                        </c:when>
                        <c:when test="${order.staTus == 'DONE'}">
                            <span class="badge badge-done">✅ Đã giao</span>
                        </c:when>
                        <c:when test="${order.staTus == 'CANCELLED'}">
                            <span class="badge" style="background:rgba(239,68,68,.1);color:#ef4444;">🚫 Đã huỷ (bom hàng)</span>
                        </c:when>
                        <c:otherwise><span class="badge">${order.staTus}</span></c:otherwise>
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

        <%-- Nút hành động --%>
        <div class="action-bar">
            <a href="${pageContext.request.contextPath}/shipper/donhang">
                <button class="btn-back">← Quay lại danh sách</button>
            </a>

            <c:if test="${order.staTus == 'READY_FOR_PICKUP'}">
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToShipping">
                    <button type="submit" class="btn-warning">📦 Xác nhận đã lấy hàng</button>
                </form>
            </c:if>
            <c:if test="${order.staTus == 'SHIPPING'}">
                <form action="${pageContext.request.contextPath}/shipper/bom-hang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <button type="submit" class="btn-danger"
                            onclick="return confirm('Xác nhận user từ chối nhận hàng (bom hàng)? Hành vi này sẽ được ghi nhận.')">
                        🚫 Báo bom hàng
                    </button>
                </form>
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToDone">
                    <button type="submit" class="btn-primary"
                            onclick="return confirm('Xác nhận đơn hàng đã giao thành công?')">
                        🎉 Hoàn thành giao đơn
                    </button>
                </form>
            </c:if>
        </div>

    </div>
</main>

<script>
    // --- THEME ---
    document.getElementById('themeToggleBtn').addEventListener('click', function() {
        var t = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
    });

    // --- CHECKLIST ---
    const ORDER_ID    = '${order.id}';
    const STORAGE_KEY = 'checklist_order_' + ORDER_ID;
    const total       = document.querySelectorAll('.checklist-item').length;

    function loadState() {
        try { return JSON.parse(localStorage.getItem(STORAGE_KEY)) || []; }
        catch(e) { return []; }
    }

    function saveState(checked) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(checked));
    }

    function updateUI(checked) {
        const count = checked.length;
        document.getElementById('checkProgress').textContent = count + '/' + total;
        document.getElementById('progressBar').style.width   = total > 0 ? (count / total * 100) + '%' : '0%';
        document.getElementById('allCheckedBanner').style.display = (count === total && total > 0) ? 'block' : 'none';

        for (let i = 0; i < total; i++) {
            const isChecked = checked.includes(i);
            const row   = document.getElementById('item-' + i);
            const box   = document.getElementById('check-' + i);
            const name  = document.getElementById('name-' + i);

            if (isChecked) {
                box.style.background     = 'var(--primary)';
                box.style.borderColor    = 'var(--primary)';
                box.innerHTML            = '<span style="color:white;font-size:13px;font-weight:900;">✓</span>';
                row.style.opacity        = '0.6';
                name.style.textDecoration = 'line-through';
            } else {
                box.style.background     = 'var(--bg-input)';
                box.style.borderColor    = 'var(--border-color)';
                box.innerHTML            = '';
                row.style.opacity        = '1';
                name.style.textDecoration = 'none';
            }
        }
    }

    function toggleCheck(index) {
        const checked = loadState();
        const pos = checked.indexOf(index);
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

    // Khởi tạo khi load trang
    document.addEventListener('DOMContentLoaded', () => updateUI(loadState()));
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

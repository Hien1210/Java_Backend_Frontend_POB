<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <script>!function(){var t=localStorage.getItem("shipper-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhận đơn - POB Shipper</title>
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
            --danger:#ef4444;
            --font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        *{box-sizing:border-box;margin:0;padding:0;font-family:var(--font-family);transition:background-color .25s,border-color .25s}
        body{background:var(--bg-base);color:var(--text-main);display:flex;height:100vh;overflow:hidden}
        a{text-decoration:none;color:inherit}

        /* SIDEBAR */
        .sidebar{width:260px;background:var(--bg-card);border-right:1px solid var(--border-color);display:flex;flex-direction:column;flex-shrink:0;z-index:10}
        .brand{padding:24px;display:flex;align-items:center;gap:12px;border-bottom:1px solid var(--border-color)}
        .logo{background:linear-gradient(135deg,var(--primary),#2e7d32);color:#fff;width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px}
        .brand-title{font-weight:700;font-size:16px;letter-spacing:.5px}
        .menu{padding:20px 12px;flex:1}
        .menu-item{padding:14px 16px;display:flex;align-items:center;gap:12px;color:var(--text-muted);font-size:14px;font-weight:600;border-radius:8px;margin-bottom:6px}
        .menu-item:hover{background:var(--bg-input);color:var(--text-main);transform:translateX(4px)}
        .menu-item.active{background:var(--secondary-light);color:var(--secondary)}
        .online-toggle-wrap{padding:16px 12px;border-top:1px solid var(--border-color)}
        .online-toggle-btn{width:100%;padding:12px 16px;border-radius:10px;border:none;cursor:pointer;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:700;transition:all .2s}
        .online-toggle-btn.is-online{background:var(--primary-light);color:var(--primary);border:1.5px solid var(--primary)}
        .online-toggle-btn.is-offline{background:rgba(239,68,68,.08);color:#ef4444;border:1.5px solid rgba(239,68,68,.3)}
        .toggle-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
        .toggle-dot.online{background:var(--primary);animation:pulse-green 1.5s infinite}
        .toggle-dot.offline{background:#ef4444}
        @keyframes pulse-green{0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,.25)}50%{box-shadow:0 0 0 6px rgba(76,175,80,.1)}}

        /* MAIN */
        .main{flex:1;display:flex;flex-direction:column;overflow:hidden}
        .topbar{background:var(--topbar-bg);backdrop-filter:blur(10px);padding:16px 32px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border-color)}
        .topbar h1{font-size:18px;font-weight:700;display:flex;align-items:center;gap:8px}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .theme-toggle{background:var(--bg-input);border:1px solid var(--border-color);width:38px;height:38px;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px}
        .avatar-circle{background:var(--primary);color:white;width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700}
        .btn-logout{padding:8px 16px;border-radius:8px;background:rgba(239,68,68,.1);color:var(--danger);font-size:13px;font-weight:600}
        .btn-logout:hover{background:var(--danger);color:white}

        /* CONTENT */
        .content{padding:24px 32px;overflow-y:auto;flex:1;display:flex;flex-direction:column;gap:16px;animation:fadeIn .3s ease-out}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}

        /* ORDER CARDS */
        .order-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:20px;box-shadow:var(--shadow);position:relative;overflow:hidden;transition:box-shadow .2s}
        .order-card:hover{box-shadow:0 8px 24px rgba(0,0,0,.1)}
        .order-card::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%;background:var(--secondary)}

        .route-timeline{display:flex;flex-direction:column;gap:10px;margin:14px 0}
        .route-step{font-size:13px}
        .route-label{font-size:11px;color:var(--text-muted);font-weight:700;text-transform:uppercase;margin-bottom:2px}
        .route-text{font-weight:600;color:var(--text-main)}
        .route-sub{font-size:11px;color:var(--text-muted);margin-top:2px}

        .order-footer{display:flex;justify-content:space-between;align-items:center;border-top:1px dashed var(--border-color);padding-top:14px;margin-top:4px}
        .price-wrap{display:flex;flex-direction:column;gap:2px}
        .price-label{font-size:11px;color:var(--text-muted);font-weight:700;text-transform:uppercase}
        .price-val{font-size:16px;font-weight:800;color:var(--primary)}
        .fee-val{font-size:13px;font-weight:700;color:var(--secondary)}

        .badge-payment{padding:3px 9px;border-radius:6px;font-size:11px;font-weight:700}
        .badge-cod{background:var(--secondary-light);color:var(--secondary)}
        .badge-bank{background:rgba(59,130,246,.1);color:#3b82f6}
        .badge-payos{background:rgba(139,92,246,.1);color:#8b5cf6}

        .btn-accept{padding:10px 22px;border-radius:10px;border:none;background:var(--primary);color:white;font-size:14px;font-weight:700;cursor:pointer;box-shadow:0 4px 12px rgba(76,175,80,.3);transition:all .2s}
        .btn-accept:hover{background:var(--primary-hover);transform:translateY(-1px)}

        /* ALERT */
        .alert{border-radius:10px;padding:12px 16px;font-size:13px;font-weight:600;margin-bottom:4px}
        .alert-warning{background:rgba(255,152,0,.1);border:1px solid rgba(255,152,0,.3);color:var(--secondary)}
        .alert-danger{background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:var(--danger)}
        .alert-success{background:var(--primary-light);border:1px solid var(--primary);color:var(--primary)}

        /* EMPTY */
        .empty-state{background:var(--bg-card);border:1px dashed var(--border-color);border-radius:14px;padding:56px 24px;text-align:center;color:var(--text-muted)}

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
        <div>
            <div class="brand-title">POB SHIPPER</div>
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
            <li class="menu-item"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/nhan-don">
            <li class="menu-item active"><span>📥 Nhận đơn mới</span></li>
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
        <h1>📥 Danh sách đơn chờ nhận</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-btn" id="avatarBtn"><c:choose><c:when test="${not empty sessionScope.account.avatarUrl}"><img src="${sessionScope.account.avatarUrl}" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"/></c:when><c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</c:otherwise></c:choose></div>
        </div>
    </header>

    <div class="content">

        <%-- Thông báo --%>
        <c:if test="${not sessionScope.account.online}">
            <div class="alert alert-warning">
                ⚠️ Bạn đang <strong>Offline</strong> — Bật Online ở sidebar để có thể nhận đơn.
            </div>
        </c:if>
        <c:if test="${param.error eq 'taken'}">
            <div class="alert alert-danger">
                ❌ Đơn hàng này vừa được shipper khác nhận trước. Vui lòng chọn đơn khác.
            </div>
        </c:if>
        <c:if test="${param.error eq 'offline'}">
            <div class="alert alert-danger">
                ❌ Bạn cần bật <strong>Online</strong> trước khi nhận đơn.
            </div>
        </c:if>

        <%-- Header + đếm đơn --%>
        <div style="display:flex;align-items:center;justify-content:space-between;">
            <div>
                <span style="font-size:14px;font-weight:700;color:var(--text-muted);">
                    Có <span style="color:var(--secondary);font-size:18px;">${fn:length(availableOrders)}</span>
                    đơn đang chờ shipper nhận
                </span>
            </div>
            <a href="${pageContext.request.contextPath}/shipper/nhan-don"
               style="font-size:13px;font-weight:700;color:var(--primary);border:1px solid var(--primary);
                      padding:7px 14px;border-radius:8px;display:inline-flex;align-items:center;gap:6px;">
                🔄 Làm mới
            </a>
        </div>

        <%-- Danh sách đơn available --%>
        <c:choose>
            <c:when test="${empty availableOrders}">
                <div class="empty-state">
                    <div style="font-size:48px;margin-bottom:12px;">📭</div>
                    <div style="font-size:15px;font-weight:700;margin-bottom:6px;">Không có đơn nào chờ nhận</div>
                    <div style="font-size:13px;">Hãy bật Online và chờ đơn mới từ hệ thống.</div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${availableOrders}">
                    <div class="order-card">
                        <%-- Header card --%>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:4px;">
                            <span style="font-weight:800;font-size:15px;">Đơn #${order.id}</span>
                            <span style="font-size:11px;color:var(--text-muted);">🕒 ${order.createdAt}</span>
                        </div>

                        <%-- Tuyến đường --%>
                        <div class="route-timeline">
                            <div class="route-step">
                                <div class="route-label">🏪 Lấy hàng tại</div>
                                <div class="route-text">${order.shopName}</div>
                                <div class="route-sub">📍 ${order.shopAddress}</div>
                                <div class="route-sub">📞 ${order.shopPhone}</div>
                            </div>
                            <div style="border-left:2px dashed var(--border-color);margin-left:6px;height:14px;"></div>
                            <div class="route-step">
                                <div class="route-label">🏠 Giao tới khách</div>
                                <div class="route-text">${order.receiverName}</div>
                                <div class="route-sub">📍 ${order.shippingAddress}</div>
                                <div class="route-sub">📞 ${order.receiverPhone}</div>
                            </div>
                        </div>

                        <%-- Footer: giá + nút nhận --%>
                        <div class="order-footer">
                            <div style="display:flex;gap:20px;align-items:flex-end;">
                                <div class="price-wrap">
                                    <div class="price-label">Tổng đơn</div>
                                    <div class="price-val">
                                        <fmt:formatNumber value="${empty order.totalPrice ? 0 : order.totalPrice}" type="number" maxFractionDigits="0"/>đ
                                    </div>
                                </div>
                                <div class="price-wrap">
                                    <div class="price-label">Phí ship</div>
                                    <div class="fee-val">
                                        <fmt:formatNumber value="${empty order.deliveryFee ? 0 : order.deliveryFee}" type="number" maxFractionDigits="0"/>đ
                                    </div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'PAYOS'}">
                                            <span class="badge-payment badge-payos">🏦 PayOS</span>
                                        </c:when>
                                        <c:when test="${order.paymentMethod == 'BANK'}">
                                            <span class="badge-payment badge-bank">📱 QR</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-payment badge-cod">💵 COD</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <%-- Nút nhận đơn --%>
                            <c:choose>
                                <c:when test="${sessionScope.account.online}">
                                    <form action="${pageContext.request.contextPath}/shipper/nhan-don" method="post">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <button type="submit" class="btn-accept"
                                                onclick="return confirm('Xác nhận nhận đơn #${order.id}?')">
                                            ✅ Nhận đơn này
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button disabled style="padding:10px 22px;border-radius:10px;border:none;
                                            background:var(--border-color);color:var(--text-muted);
                                            font-size:14px;font-weight:700;cursor:not-allowed;">
                                        🔴 Cần Online
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<script>
    const html = document.documentElement;
    html.setAttribute('data-theme', localStorage.getItem('shipper-theme') || 'light');
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
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

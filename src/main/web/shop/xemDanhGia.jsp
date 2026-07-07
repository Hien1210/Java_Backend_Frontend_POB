<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem đánh giá - POB Shop</title>
    <style>
        :root {
            --bg-base: #FFF8F1;
            --bg-sidebar: #FFFFFF;
            --bg-panel: #FFFFFF;
            --bg-input: #FFF3E9;
            --bg-hover: #FFF1E4;
            --border-color: #FBE3CF;
            --text-main: #3A2A1E;
            --text-muted: #9C8579;
            --text-dim: #C2A992;
            --primary: #FF7A30;
            --primary-dark: #E8590C;
            --primary-light: rgba(255, 122, 48, 0.12);
            --accent: #E63946;
            --accent-light: rgba(230, 57, 70, 0.1);
            --success: #2ECC71;
            --success-light: rgba(46, 204, 113, 0.12);
            --warning: #FFB703;
            --warning-light: rgba(255, 183, 3, 0.15);
            --shadow-sm: 0 2px 6px rgba(58, 42, 30, 0.06);
            --shadow-md: 0 8px 20px rgba(58, 42, 30, 0.10);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-brand { padding: 22px 24px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); }
        .brand-row { display: flex; align-items: center; gap: 12px; }
        .logo-icon { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(255, 122, 48, 0.35); }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 800; font-size: 15px; }
        .brand-subtitle { color: var(--primary); font-size: 11px; font-weight: 600; }
        .hi-owner { font-size: 12px; color: var(--text-muted); padding-left: 2px; }
        .hi-owner strong { color: var(--primary-dark); }
        .menu-section { padding: 16px 0; overflow-y: auto; flex: 1; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 16px 24px 8px; font-weight: 700; letter-spacing: 0.5px; }
        .menu-item { padding: 12px 24px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 13.5px; font-weight: 500; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--primary-dark); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary-dark); border-left-color: var(--primary); font-weight: 700; }
        .menu-item-left { display: flex; align-items: center; gap: 12px; }

        /* MAIN */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { height: 72px; background-color: var(--bg-sidebar); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 19px; font-weight: 800; }
        .header-actions { display: flex; align-items: center; gap: 16px; }
        .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--warning), var(--primary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 14px; box-shadow: var(--shadow-sm); }
        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 9px 16px; border-radius: 10px; background: var(--accent-light); color: var(--accent); font-size: 13px; font-weight: 700; border: 1px solid transparent; transition: all 0.2s ease; }
        .btn-logout:hover { background: var(--accent); color: white; transform: translateY(-1px); }

        .content-wrapper { padding: 32px; overflow-y: auto; flex: 1; }

        /* PANEL */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; box-shadow: var(--shadow-sm); overflow: hidden; }

        /* OVERVIEW */
        .overview-card { background: linear-gradient(120deg, var(--primary) 0%, var(--accent) 100%); border-radius: 14px; padding: 24px 28px; color: #fff; margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--shadow-md); }
        .overview-rating { font-size: 52px; font-weight: 900; line-height: 1; }
        .overview-stars { display: flex; gap: 4px; margin: 6px 0; font-size: 20px; }
        .overview-count { font-size: 13px; opacity: 0.88; }
        .overview-info h2 { font-size: 20px; font-weight: 800; margin-bottom: 4px; }
        .overview-info p { font-size: 13px; opacity: 0.88; }
        .overview-emoji { font-size: 52px; }

        /* TABS */
        .tab-bar { display: flex; border-bottom: 1px solid var(--border-color); }
        .tab-btn { flex: 1; padding: 16px; font-size: 14px; font-weight: 600; color: var(--text-muted); background: none; border: none; cursor: pointer; border-bottom: 3px solid transparent; transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .tab-btn:hover { color: var(--primary-dark); background: var(--bg-hover); }
        .tab-btn.active { color: var(--primary-dark); border-bottom-color: var(--primary); background: var(--primary-light); font-weight: 700; }
        .tab-badge { font-size: 11px; padding: 2px 8px; border-radius: 12px; font-weight: 700; }
        .tab-badge.blue { background: rgba(59,130,246,0.12); color: #2563eb; }
        .tab-badge.green { background: var(--success-light); color: #1E8449; }

        .tab-panel { display: none; padding: 24px; }
        .tab-panel.active { display: block; }

        /* REVIEW CARD */
        .review-list { display: flex; flex-direction: column; gap: 14px; }
        .review-card { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 12px; padding: 18px; transition: all 0.2s; }
        .review-card:hover { background: var(--bg-hover); box-shadow: var(--shadow-sm); }
        .review-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 10px; }
        .reviewer-info { display: flex; align-items: center; gap: 10px; }
        .reviewer-avatar { width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 15px; flex-shrink: 0; }
        .reviewer-avatar.user-type { background: rgba(59,130,246,0.15); color: #2563eb; }
        .reviewer-avatar.shipper-type { background: var(--success-light); color: #1E8449; }
        .reviewer-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .reviewer-order { font-size: 12px; color: var(--text-muted); }
        .review-meta { display: flex; align-items: center; gap: 8px; }
        .stars { display: flex; gap: 2px; font-size: 15px; }
        .star-filled { color: #FFB703; }
        .star-empty { color: var(--border-color); }
        .review-date { font-size: 12px; color: var(--text-dim); }
        .review-comment { font-size: 13.5px; color: var(--text-main); line-height: 1.65; padding-top: 4px; }

        .empty-state { text-align: center; padding: 56px 20px; color: var(--text-dim); }
        .empty-state .empty-icon { font-size: 52px; margin-bottom: 12px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-row">
            <div class="logo-icon">🍔</div>
            <div class="brand-text">
                <span class="brand-title">${not empty shop.shopName ? shop.shopName : 'CỬA HÀNG CỦA TÔI'}</span>
                <span class="brand-subtitle">SHOP OWNER</span>
            </div>
        </div>
        <div class="hi-owner">👋 Hi, <strong>${sessionScope.account.userName}</strong></div>
    </div>

    <div class="menu-section">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📊</span> Trang chủ</div>
        </a>

        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🍽️</span> Quản lý sản phẩm</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📂</span> Quản lý loại sản phẩm</div>
        </a>

        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧂</span> Quản lý Topping</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏷️</span> Quản lý loại Topping</div>
        </a>

        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧾</span> Bấm Bill</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📋</span> Quản lý hóa đơn</div>
        </a>

        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏪</span> Thông tin cửa hàng</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item active">
            <div class="menu-item-left"><span style="font-size:16px;">⭐</span> Xem đánh giá</div>
        </a>
    </div>
</aside>

<main class="main-content">
    <header class="top-header">
        <h2>⭐ XEM ĐÁNH GIÁ</h2>
        <div class="header-actions">
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <!-- Overview banner -->
        <div class="overview-card">
            <div>
                <div class="overview-rating"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></div>
                <div class="overview-stars">
                    <c:forEach begin="1" end="5" var="i">
                        <span class="${i <= avgRating ? 'star-filled' : 'star-empty'}">★</span>
                    </c:forEach>
                </div>
                <div class="overview-count">${totalFeedback} đánh giá tổng cộng</div>
            </div>
            <div class="overview-info">
                <h2>${shop.shopName}</h2>
                <p>Đánh giá từ khách hàng và shipper của cửa hàng bạn</p>
            </div>
            <div class="overview-emoji">⭐</div>
        </div>

        <!-- Tab panel -->
        <div class="panel">
            <div class="tab-bar">
                <button class="tab-btn active" onclick="switchTab('user')" id="tab-user">
                    👤 Từ Khách hàng
                    <span class="tab-badge blue">${feedbackUser.size()}</span>
                </button>
                <button class="tab-btn" onclick="switchTab('shipper')" id="tab-shipper">
                    🛵 Từ Shipper
                    <span class="tab-badge green">${feedbackShipper.size()}</span>
                </button>
            </div>

            <!-- Tab User -->
            <div class="tab-panel active" id="panel-user">
                <c:choose>
                    <c:when test="${empty feedbackUser}">
                        <div class="empty-state">
                            <div class="empty-icon">💬</div>
                            <p>Chưa có đánh giá từ khách hàng</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-list">
                            <c:forEach var="fb" items="${feedbackUser}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar user-type">
                                                ${fb.anonymous ? '?' : fn:toUpperCase(fn:substring(fb.reviewerName, 0, 1))}
                                            </div>
                                            <div>
                                                <div class="reviewer-name">${fb.anonymous ? 'Ẩn danh' : fb.reviewerName}</div>
                                                <div class="reviewer-order">Đơn #${fb.orderId}</div>
                                            </div>
                                        </div>
                                        <div class="review-meta">
                                            <div class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="review-date">
                                                <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty fb.comment}">
                                        <div class="review-comment">${fn:escapeXml(fb.comment)}</div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Tab Shipper -->
            <div class="tab-panel" id="panel-shipper">
                <c:choose>
                    <c:when test="${empty feedbackShipper}">
                        <div class="empty-state">
                            <div class="empty-icon">🛵</div>
                            <p>Chưa có đánh giá từ shipper</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="review-list">
                            <c:forEach var="fb" items="${feedbackShipper}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar shipper-type">
                                                ${fn:toUpperCase(fn:substring(fb.reviewerName, 0, 1))}
                                            </div>
                                            <div>
                                                <div class="reviewer-name">${fb.reviewerName}</div>
                                                <div class="reviewer-order">Đơn #${fb.orderId}</div>
                                            </div>
                                        </div>
                                        <div class="review-meta">
                                            <div class="stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span class="${i <= fb.rating ? 'star-filled' : 'star-empty'}">★</span>
                                                </c:forEach>
                                            </div>
                                            <span class="review-date">
                                                <fmt:formatDate value="${fb.createdAt}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty fb.comment}">
                                        <div class="review-comment">${fn:escapeXml(fb.comment)}</div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('tab-' + tab).classList.add('active');
        document.getElementById('panel-' + tab).classList.add('active');
    }
</script>
</body>
</html>

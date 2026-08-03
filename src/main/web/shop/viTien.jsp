<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentShop" value="${shop}" scope="request"/>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ví tiền - ${not empty shop.shopName ? shop.shopName : 'Cửa hàng'}</title>
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
        .wallet-hero { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%); border-radius: 20px; padding: 36px 32px; color: #fff; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px; margin-bottom: 24px; position: relative; overflow: hidden; }
        .wallet-hero::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E") repeat; }
        .wallet-balance-section { position: relative; z-index: 1; }
        .wallet-balance-label { font-size: 13px; opacity: .7; margin-bottom: 6px; letter-spacing: .05em; text-transform: uppercase; }
        .wallet-balance-amount { display: flex; align-items: baseline; gap: 6px; font-size: 42px; font-weight: 800; letter-spacing: -1px; line-height: 1; }
        .wallet-balance-amount span { font-size: 20px; font-weight: 600; opacity: .8; }
        .wallet-chip { background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.2); border-radius: 10px; padding: 6px 14px; font-size: 12px; font-weight: 600; letter-spacing: .05em; margin-top: 12px; display: inline-block; }
        .wallet-actions-hero { display: flex; gap: 12px; flex-wrap: wrap; position: relative; z-index: 1; }
        .btn-hero {
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
            padding: 12px 24px; border-radius: 12px; font-weight: 700; font-size: 14px;
            border: 2px solid; cursor: pointer; transition: .18s;
            text-decoration: none; white-space: nowrap; line-height: 1.2;
        }
        .btn-hero-primary { background: #fff; color: #0f3460; border-color: #fff; }
        .btn-hero-primary:hover { background: #e8f0fe; }
        .btn-hero-outline { background: transparent; color: #fff; border-color: rgba(255,255,255,.4); }
        .btn-hero-outline:hover { background: rgba(255,255,255,.1); border-color: #fff; }
        /* body.dash-body a có specificity cao hơn .btn-hero-primary/.btn-hero-outline nên
           "color: inherit" đè mất màu chữ đã định nghĩa ở trên — khai báo lại đúng độ ưu tiên
           ở đây, cùng convention với dashboard.css (xem body.dash-body a.btn-primary/...) */
        body.dash-body a.btn-hero-primary { color: #0f3460; }
        body.dash-body a.btn-hero-outline { color: #fff; }

        .stat-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 20px; display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; }
        .stat-card .sc-text { min-width: 0; }
        .stat-card .sc-label { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: .06em; margin-bottom: 8px; white-space: nowrap; }
        .stat-card .sc-value { font-size: 22px; font-weight: 800; color: var(--text-main); white-space: nowrap; }
        .stat-card .sc-icon { font-size: 28px; opacity: .35; flex-shrink: 0; line-height: 1; }
        .stat-card.green .sc-value { color: #16a34a; }
        .stat-card.blue .sc-value { color: var(--primary); }
        .stat-card.orange .sc-value { color: #ea580c; }

        .section-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; margin-bottom: 24px; overflow: hidden; }
        .section-card-header { padding: 16px 20px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; }
        .section-card-header h3 { font-size: 15px; font-weight: 700; color: var(--text-main); }
        .section-card-body { padding: 0; }

        .tx-table { width: 100%; border-collapse: collapse; font-size: 13.5px; }
        .tx-table th { padding: 10px 14px; text-align: left; font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: .06em; background: var(--bg-input); }
        .tx-table td { padding: 12px 14px; border-bottom: 1px solid var(--border-color); vertical-align: middle; }
        .tx-table tr:last-child td { border-bottom: none; }
        .tx-table tr:hover td { background: var(--bg-input); }
        .tx-type { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 6px; }
        .tx-type.EARNING { background: #dcfce7; color: #15803d; }
        .tx-type.WITHDRAWAL { background: #fef3c7; color: #92400e; }
        .tx-type.REFUND { background: #fee2e2; color: #b91c1c; }
        .tx-amount.positive { color: #16a34a; font-weight: 700; }
        .tx-amount.negative { color: #dc2626; font-weight: 700; }

        .badge-status { display: inline-block; padding: 3px 10px; border-radius: 6px; font-size: 11px; font-weight: 700; }
        .badge-status.PENDING { background: #fef3c7; color: #92400e; }
        .badge-status.APPROVED { background: #dcfce7; color: #15803d; }
        .badge-status.REJECTED { background: #fee2e2; color: #b91c1c; }

        .withdraw-form { padding: 20px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { margin-bottom: 14px; }
        .form-group label { font-size: 12px; font-weight: 700; color: var(--text-muted); display: block; margin-bottom: 4px; text-transform: uppercase; letter-spacing: .04em; }
        .form-group input { width: 100%; padding: 10px 12px; border-radius: 8px; border: 1.5px solid var(--border-color); background: var(--bg-input); color: var(--text-main); font-size: 14px; }
        .form-group input:focus { outline: none; border-color: var(--primary); }
        .amount-hint { font-size: 11px; color: var(--text-muted); margin-top: 3px; }
        .submit-btn { width: 100%; padding: 12px; border-radius: 10px; background: var(--primary); color: #fff; font-size: 14px; font-weight: 700; border: none; cursor: pointer; transition: .18s; margin-top: 6px; }
        .submit-btn:hover { background: var(--primary-dark); }

        .pager { display: flex; gap: 8px; justify-content: center; padding: 16px; }
        .pager a { padding: 6px 12px; border-radius: 8px; border: 1px solid var(--border-color); color: var(--text-muted); font-size: 13px; font-weight: 600; }
        .pager a.active, .pager a:hover { background: var(--primary); color: #fff; border-color: var(--primary); }

        .empty-state { text-align: center; padding: 40px 20px; color: var(--text-muted); font-size: 14px; }
        .alert { padding: 12px 16px; border-radius: 10px; margin-bottom: 16px; font-size: 14px; font-weight: 600; }
        .alert-success { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .alert-danger  { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        .info-box { background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 10px; padding: 14px 16px; margin-bottom: 20px; font-size: 13px; color: #1d4ed8; }
    </style>
</head>
<body class="dash-body">

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">🍔</div>
        <div class="brand-text">
            <span class="brand-title">${not empty shop.shopName ? shop.shopName : 'CỬA HÀNG'}</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
        <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" onclick="pobToggleSidebar()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
        </button>
    </div>
    <div class="menu">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📊</span><span class="mi-label"> Trang chủ</span></span>
        </a>
        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🍽️</span><span class="mi-label"> Quản lý sản phẩm</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📂</span><span class="mi-label"> Quản lý loại sản phẩm</span></span>
        </a>
        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧂</span><span class="mi-label"> Quản lý Topping</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏷️</span><span class="mi-label"> Quản lý loại Topping</span></span>
        </a>
        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🧾</span><span class="mi-label"> Bấm Bill</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span><span class="mi-label"> Quản lý hóa đơn</span></span>
        </a>
        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span><span class="mi-label"> Thông tin cửa hàng</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/danh-gia" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⭐</span><span class="mi-label"> Xem đánh giá</span></span>
        </a>
        <div class="menu-title">Khuyến mãi</div>
        <a href="${pageContext.request.contextPath}/shop/combo" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🎁</span><span class="mi-label"> Quản lý Combo</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/shop/flash-sale" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⚡</span><span class="mi-label"> Flash Sale</span></span>
        </a>
        <div class="menu-title">Tài chính</div>
        <a href="${pageContext.request.contextPath}/shop/vi-tien" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">💰</span><span class="mi-label"> Ví tiền Shop</span></span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>💰 Ví tiền Shop</h1>
        </div>
        <div class="topbar-right">
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

        <c:if test="${param.success eq '1'}">
            <div class="alert alert-success">✅ Yêu cầu rút tiền đã được gửi! Admin sẽ xử lý trong 1-2 ngày làm việc.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">⚠️ ${error}</div>
        </c:if>

        <%-- Hero Wallet Card --%>
        <div class="wallet-hero">
            <div class="wallet-balance-section">
                <div class="wallet-balance-label">Số dư khả dụng</div>
                <div class="wallet-balance-amount">
                    <span>₫</span><fmt:formatNumber value="${wallet.balance}" pattern="#,##0"/>
                </div>
                <div class="wallet-chip">💳 ${shop.shopName}</div>
            </div>
            <div class="wallet-actions-hero">
                <a href="#withdraw-section" class="btn-hero btn-hero-primary">⬇️ Rút tiền</a>
                <a href="#history-section" class="btn-hero btn-hero-outline">📄 Lịch sử</a>
            </div>
        </div>

        <%-- Stats --%>
        <div class="stat-grid">
            <div class="stat-card green">
                <div class="sc-text">
                    <div class="sc-label">Tổng đã thu về</div>
                    <div class="sc-value">₫<fmt:formatNumber value="${wallet.totalEarned}" pattern="#,##0"/></div>
                </div>
                <div class="sc-icon">💵</div>
            </div>
            <div class="stat-card blue">
                <div class="sc-text">
                    <div class="sc-label">Tổng đã rút</div>
                    <div class="sc-value">₫<fmt:formatNumber value="${wallet.totalWithdrawn}" pattern="#,##0"/></div>
                </div>
                <div class="sc-icon">🏦</div>
            </div>
            <div class="stat-card orange">
                <div class="sc-text">
                    <div class="sc-label">Đang chờ duyệt</div>
                    <div class="sc-value">
                        <c:set var="pendingTotal" value="0"/>
                        <c:forEach var="w" items="${withdrawals}">
                            <c:if test="${w.status eq 'PENDING'}">
                                <c:set var="pendingTotal" value="${pendingTotal + w.amount}"/>
                            </c:if>
                        </c:forEach>
                        ₫<fmt:formatNumber value="${pendingTotal}" pattern="#,##0"/>
                    </div>
                </div>
                <div class="sc-icon">⏳</div>
            </div>
        </div>

        <%-- Transaction History --%>
        <div class="section-card" id="history-section">
            <div class="section-card-header">
                <h3>📄 Lịch sử giao dịch</h3>
                <c:if test="${totalPages > 1}">
                    <span style="font-size:12px;color:var(--text-muted)">Trang ${currentPage}/${totalPages}</span>
                </c:if>
            </div>
            <div class="section-card-body">
                <c:choose>
                    <c:when test="${empty transactions}">
                        <div class="empty-state">Chưa có giao dịch nào</div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x:auto">
                        <table class="tx-table">
                            <thead>
                                <tr>
                                    <th>Loại</th>
                                    <th>Số tiền</th>
                                    <th>Mô tả</th>
                                    <th>Đơn #</th>
                                    <th>Thời gian</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="tx" items="${transactions}">
                                    <tr>
                                        <td>
                                            <span class="tx-type ${tx.type}">
                                                <c:choose>
                                                    <c:when test="${tx.type eq 'EARNING'}">💵 Thu nhập</c:when>
                                                    <c:when test="${tx.type eq 'WITHDRAWAL'}">🏦 Rút tiền</c:when>
                                                    <c:otherwise>↩️ Hoàn tiền</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="tx-amount ${tx.amount >= 0 ? 'positive' : 'negative'}">
                                                ${tx.amount >= 0 ? '+' : ''}₫<fmt:formatNumber value="${tx.amount}" pattern="#,##0"/>
                                            </span>
                                        </td>
                                        <td style="max-width:280px;font-size:12.5px;color:var(--text-muted)">${tx.description}</td>
                                        <td>
                                            <c:if test="${not empty tx.orderId}">
                                                <a href="${pageContext.request.contextPath}/shop/bills?action=view&orderId=${tx.orderId}" style="color:var(--primary);font-weight:700">#${tx.orderId}</a>
                                            </c:if>
                                        </td>
                                        <td style="font-size:12px;color:var(--text-muted);white-space:nowrap">
                                            <fmt:formatDate value="${tx.createdAt}" pattern="dd/MM/yyyy HH:mm" type="both"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        </div>
                        <c:if test="${totalPages > 1}">
                            <div class="pager">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}">← Trước</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="?page=${p}" class="${p eq currentPage ? 'active' : ''}">${p}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}">Sau →</a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Withdrawal Form --%>
        <div class="section-card" id="withdraw-section">
            <div class="section-card-header">
                <h3>⬇️ Yêu cầu rút tiền</h3>
            </div>
            <div class="withdraw-form">
                <div class="info-box">
                    💡 Tiền sẽ được chuyển khoản đến tài khoản ngân hàng của bạn trong <strong>1-2 ngày làm việc</strong> sau khi admin duyệt. Số tiền rút tối thiểu <strong>100.000đ</strong>.
                </div>
                <form method="post" action="${pageContext.request.contextPath}/shop/vi-tien">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Số tiền muốn rút (VNĐ) *</label>
                            <input type="number" name="amount" min="100000" step="1000"
                                   max="${wallet.balance}" placeholder="Ví dụ: 500000" required/>
                            <div class="amount-hint">Số dư khả dụng: ₫<fmt:formatNumber value="${wallet.balance}" pattern="#,##0"/></div>
                        </div>
                        <div class="form-group">
                            <label>Ngân hàng *</label>
                            <input type="text" name="bankName" placeholder="VD: Vietcombank, BIDV, MB..." required/>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Số tài khoản *</label>
                            <input type="text" name="bankAccountNumber" placeholder="Số tài khoản ngân hàng" required/>
                        </div>
                        <div class="form-group">
                            <label>Tên chủ tài khoản *</label>
                            <input type="text" name="bankAccountHolder" placeholder="VD: NGUYEN VAN A" required/>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">💸 Gửi yêu cầu rút tiền</button>
                </form>
            </div>
        </div>

        <%-- Withdrawal History --%>
        <div class="section-card">
            <div class="section-card-header">
                <h3>📊 Lịch sử yêu cầu rút tiền</h3>
            </div>
            <div class="section-card-body">
                <c:choose>
                    <c:when test="${empty withdrawals}">
                        <div class="empty-state">Chưa có yêu cầu rút tiền nào</div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x:auto">
                        <table class="tx-table">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Số tiền</th>
                                    <th>Ngân hàng</th>
                                    <th>Số TK</th>
                                    <th>Chủ TK</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="wd" items="${withdrawals}">
                                    <tr>
                                        <td style="font-size:12px;white-space:nowrap">
                                            <fmt:formatDate value="${wd.requestedAt}" pattern="dd/MM/yyyy HH:mm" type="both"/>
                                        </td>
                                        <td style="font-weight:700;color:#dc2626">-₫<fmt:formatNumber value="${wd.amount}" pattern="#,##0"/></td>
                                        <td>${wd.bankName}</td>
                                        <td style="font-family:monospace">${wd.bankAccountNumber}</td>
                                        <td>${wd.bankAccountHolder}</td>
                                        <td><span class="badge-status ${wd.status}">
                                            <c:choose>
                                                <c:when test="${wd.status eq 'PENDING'}">⏳ Đang duyệt</c:when>
                                                <c:when test="${wd.status eq 'APPROVED'}">✅ Đã duyệt</c:when>
                                                <c:otherwise>❌ Từ chối</c:otherwise>
                                            </c:choose>
                                        </span></td>
                                        <td style="font-size:12px;color:var(--text-muted)">
                                            <c:if test="${not empty wd.rejectReason}">${wd.rejectReason}</c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">🏪 Shop Owner</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/shop/ho-so" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/shop/doi-mat-khau" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/pob-dialog.js"></script>
<script>
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
</script>
</body>
</html>

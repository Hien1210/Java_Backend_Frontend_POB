// Nav scroll effect
const header = document.getElementById('header');
window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 50);
});

// Scroll reveal
const revealEls = document.querySelectorAll('.reveal');
const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('active'); });
}, { threshold: 0.1 });
revealEls.forEach(el => observer.observe(el));

// Cart state
let cart = [];
let currentProduct = null;

const cartBadge = document.getElementById('cart-badge');
const cartOverlay = document.getElementById('cart-overlay');
const cartSidebar = document.getElementById('cart-sidebar');
const cartItemsContainer = document.getElementById('cart-items-container');
const cartEmptyMsg = document.getElementById('cart-empty-msg');
const cartTotalPrice = document.getElementById('cart-total-price');
const modalOverlay = document.getElementById('product-modal-overlay');

function formatVND(amount) {
    return amount.toLocaleString('vi-VN') + ' ₫';
}

function updateCartBadge() {
    cartBadge.textContent = cart.length;
}

function renderCart() {
    const items = cartItemsContainer.querySelectorAll('.cart-item');
    items.forEach(i => i.remove());

    if (cart.length === 0) {
        cartEmptyMsg.style.display = 'block';
        cartTotalPrice.textContent = '0 ₫';
        return;
    }

    cartEmptyMsg.style.display = 'none';
    let total = 0;

    cart.forEach((item, idx) => {
        total += item.total;
        const div = document.createElement('div');
        div.className = 'cart-item';
        const imgHtml = item.img
            ? `<img src="${item.img}" alt="${item.name}" class="cart-item-img">`
            : `<div class="cart-item-img" style="display:flex;align-items:center;justify-content:center;font-size:2rem;">${item.emoji || '🍽️'}</div>`;
        const toppingsText = item.toppings.length ? item.toppings.join(', ') : 'Không có topping';
        div.innerHTML = `
            ${imgHtml}
            <div class="cart-item-info">
                <h4>${item.name}</h4>
                <div class="cart-item-toppings">${toppingsText}</div>
                <div class="cart-item-price-row">
                    <span class="cart-item-price">${formatVND(item.total)}</span>
                    <button class="cart-item-remove" data-idx="${idx}">Xóa</button>
                </div>
            </div>`;
        cartItemsContainer.appendChild(div);
    });

    cartTotalPrice.textContent = formatVND(total);

    cartItemsContainer.querySelectorAll('.cart-item-remove').forEach(btn => {
        btn.addEventListener('click', () => {
            cart.splice(parseInt(btn.dataset.idx), 1);
            updateCartBadge();
            renderCart();
        });
    });
}

function openCart() {
    cartSidebar.classList.add('open');
    cartOverlay.classList.add('active');
}

function closeCart() {
    cartSidebar.classList.remove('open');
    cartOverlay.classList.remove('active');
}

document.getElementById('cart-icon-btn').addEventListener('click', openCart);
document.getElementById('btn-close-cart').addEventListener('click', closeCart);
cartOverlay.addEventListener('click', closeCart);

// Modal
function openModal(btn) {
    currentProduct = {
        id: btn.dataset.id,
        name: btn.dataset.name,
        price: parseInt(btn.dataset.price),
        img: btn.dataset.img || '',
        emoji: btn.dataset.emoji || '',
        desc: btn.dataset.desc || ''
    };

    document.getElementById('modal-product-title').textContent = currentProduct.name;
    document.getElementById('modal-product-desc').textContent = currentProduct.desc;

    const imgEl = document.getElementById('modal-product-img');
    if (currentProduct.img) {
        imgEl.src = currentProduct.img;
        imgEl.style.display = 'block';
    } else {
        imgEl.style.display = 'none';
    }

    document.querySelectorAll('.topping-checkbox').forEach(cb => cb.checked = false);
    updateModalTotal();
    modalOverlay.classList.add('active');
}

function updateModalTotal() {
    if (!currentProduct) return;
    let extra = 0;
    document.querySelectorAll('.topping-checkbox:checked').forEach(cb => {
        extra += parseInt(cb.value);
    });
    document.getElementById('modal-total-price').textContent = formatVND(currentProduct.price + extra);
}

document.querySelectorAll('.topping-checkbox').forEach(cb => {
    cb.addEventListener('change', updateModalTotal);
});

document.querySelectorAll('.btn-add').forEach(btn => {
    btn.addEventListener('click', () => openModal(btn));
});

document.getElementById('btn-close-modal').addEventListener('click', () => {
    modalOverlay.classList.remove('active');
});

modalOverlay.addEventListener('click', (e) => {
    if (e.target === modalOverlay) modalOverlay.classList.remove('active');
});

document.getElementById('btn-add-to-cart-modal').addEventListener('click', () => {
    if (!currentProduct) return;
    let extra = 0;
    const toppings = [];
    document.querySelectorAll('.topping-checkbox:checked').forEach(cb => {
        extra += parseInt(cb.value);
        toppings.push(cb.dataset.name);
    });
    cart.push({
        ...currentProduct,
        toppings,
        total: currentProduct.price + extra
    });
    updateCartBadge();
    renderCart();
    modalOverlay.classList.remove('active');
    openCart();
});

document.getElementById('btn-checkout').addEventListener('click', () => {
    if (cart.length === 0) return;
    alert('Chức năng thanh toán đang được phát triển!');
});

document.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('email-trigger-btn');
    const popup = document.getElementById('email-popup');
    const closeBtn = document.getElementById('close-popup');

    if (btn) {
        btn.addEventListener('click', () => {
            popup.style.display = 'block';
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            popup.style.display = 'none';
        });
    }
});

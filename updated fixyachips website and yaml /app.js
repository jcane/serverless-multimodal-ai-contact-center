const apiEndpoint = 'https://m4w30c04d3.execute-api.us-east-1.amazonaws.com/';

async function submitSignup() {
    const name = document.getElementById('userName').value;
    const email = document.getElementById('userEmail').value;
    const btn = document.querySelector('.submit-btn');

    if (!name || !email) {
        alert("Please provide both name and email.");
        return;
    }

    try {
        btn.innerText = "Securing...";
        btn.disabled = true;

        const response = await fetch(apiEndpoint, {
            method: 'POST',
            mode: 'cors',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, email })
        });

        if (response.ok) {
            document.querySelector('.modal-content').innerHTML = `
                <div style="padding: 20px; text-align: center;">
                    <h2 style="color: #2ecc71;">Wisdom Secured!</h2>
                    <p>Thanks, ${name}. You're on the list for the 25-video Masterclass launch.</p>
                    <button onclick="location.reload()" class="cta-btn" style="margin-top:15px;">Close</button>
                </div>
            `;
        } else {
            throw new Error('Server error');
        }
    } catch (err) {
        console.error(err);
        alert("Connection error. Please try again later.");
        btn.innerText = "Join Waitlist";
        btn.disabled = false;
    }
}

// Logic to handle Modal opening/closing
document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById("signupModal");
    const btn = document.getElementById("joinBtn") || document.getElementById("mainJoinBtn");
    const span = document.getElementsByClassName("close")[0];

    if (btn) {
        btn.onclick = () => modal.style.display = "block";
    }

    if (span) {
        span.onclick = () => modal.style.display = "none";
    }

    window.onclick = (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
});

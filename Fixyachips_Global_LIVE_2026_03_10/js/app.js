// Function to handle the Waitlist Signup
async function submitSignup() {
    const name = document.getElementById('userName').value;
    const email = document.getElementById('userEmail').value;

    if (!name || !email) {
        alert("Please provide both name and email.");
        return;
    }

    // This URL is generated once you deploy the API Gateway via CloudFormation
    const apiEndpoint = 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/prod/signup';

    const payload = {
        name: name,
        email: email,
        source: 'VOD_WAITLIST_2026'
    };

    try {
        const response = await fetch(apiEndpoint, {
            method: 'POST',
            mode: 'cors',
            body: JSON.stringify(payload)
        });

        if (response.ok) {
            alert("Wisdom Secured! Check your email for a welcome message.");
            document.getElementById('signupModal').style.display = 'none';
        } else {
            alert("Connection error. Please try again.");
        }
    } catch (error) {
        console.error("Error:", error);
    }
}

// Modal Toggle Logic
const modal = document.getElementById("signupModal");
const btn = document.getElementById("joinBtn");
const span = document.getElementsByClassName("close")[0];

if(btn) btn.onclick = () => modal.style.display = "block";
if(span) span.onclick = () => modal.style.display = "none";
window.onclick = (event) => { if (event.target == modal) modal.style.display = "none"; }

document.getElementById('emailForm').addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('userEmail').value;

    try {
        const response = await fetch('YOUR_API_GATEWAY_URL_HERE', {
            method: 'POST',
            body: JSON.stringify({ email: email }),
            headers: { 'Content-Type': 'application/json' }
        });

        if (response.ok) {
            alert("Success! You're added to our network.");
        } else {
            alert("There was an issue connecting to the database.");
        }
    } catch (error) {
        console.error("Error:", error);
    }
});

"use server";

import { Resend } from "resend";

const resendApiKey = process.env.RESEND_API_KEY;

if (!resendApiKey) {
	console.error("RESEND_API_KEY is not set in the environment variables");
}

const resend = resendApiKey ? new Resend(resendApiKey) : null;

export async function sendEmail(formData: FormData) {
	const data = {
		name: formData.get("name"),
		email: formData.get("email"),
		message: formData.get("message"),
	};

	const response = await fetch("https://formspree.io/f/xdkadbjn", {
		method: "POST",
		body: JSON.stringify(data),
		headers: {
			Accept: "application/json",
			"Content-Type": "application/json",
		},
	});

	if (!response.ok) {
		return { error: "Failed to send message. Please try again." };
	}

	return { success: true };
}

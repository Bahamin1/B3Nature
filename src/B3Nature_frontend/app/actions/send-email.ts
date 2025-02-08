"use server"

import { Resend } from "resend"

const resendApiKey = process.env.RESEND_API_KEY

if (!resendApiKey) {
  console.error("RESEND_API_KEY is not set in the environment variables")
}

const resend = resendApiKey ? new Resend(resendApiKey) : null

export async function sendEmail(formData: FormData) {
  if (!resend) {
    console.error("Resend client is not initialized due to missing API key")
    return {
      error: "Email service is not configured properly. Please contact the administrator.",
    }
  }

  try {
    const email = formData.get("email") as string
    const name = formData.get("name") as string
    const message = formData.get("message") as string

    if (!email || !name || !message) {
      return {
        error: "Please fill in all fields",
      }
    }

    const { data, error } = await resend.emails.send({
      from: `B3Nature Contact <onboarding@resend.dev>`,
      to: ["Bahamindehpour@gmail.com"],
      reply_to: email,
      subject: `New Contact Form Submission from ${name}`,
      text: `
Name: ${name}
Email: ${email}
Message: ${message}
      `,
    })

    if (error) {
      console.error("Error sending email:", error)
      return {
        error: "Failed to send email",
      }
    }

    return {
      success: true,
    }
  } catch (error) {
    console.error("Unexpected error:", error)
    return {
      error: "An unexpected error occurred. Please try again later.",
    }
  }
}


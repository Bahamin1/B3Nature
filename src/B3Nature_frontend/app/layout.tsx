import "./globals.css"
import { Inter } from "next/font/google"
import { Navigation } from "@/components/navigation"
import { Footer } from "@/components/footer"
import { Toaster } from "@/components/ui/toaster"
import type React from "react"

const inter = Inter({ subsets: ["latin"] })

export const metadata = {
  title: "B3Nature - Bridging Nature and Technology",
  description: "B3Nature is an innovative project harmonizing technology with nature for a sustainable future.",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="scroll-smooth">
      <body
        className={`${inter.className} min-h-screen bg-gradient-to-b from-background via-background/95 to-background`}
      >
        <Navigation />
        <main className="pt-16">{children}</main>
        <Footer />
        <Toaster />
      </body>
    </html>
  )
}


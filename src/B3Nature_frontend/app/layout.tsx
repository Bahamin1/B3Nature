import { Footer } from "@/components/footer";
import { Navigation } from "@/components/navigation";
import { Toaster } from "@/components/ui/toaster";
import { Inter } from "next/font/google";
import type React from "react";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
	title: "B3Nature - Bridging Nature and Technology",
	description:
		"B3Nature is an innovative project harmonizing technology with nature for a sustainable future.",
};

export default function RootLayout({
	children,
}: {
	children: React.ReactNode;
}) {
	return (
		<html lang="en" className="scroll-smooth">
			<head>
				<link rel="icon" href="/favicon.ico" />
			</head>
			<body
				className={`${inter.className} min-h-screen bg-gradient-to-b from-background via-background/95 to-background`}
			>
				<Navigation />
				<main className="pt-16">{children}</main>
				<Footer />
				<Toaster />
			</body>
		</html>
	);
}

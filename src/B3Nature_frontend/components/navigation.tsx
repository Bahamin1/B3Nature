"use client";

import { Button } from "@/components/ui/button";
import { Menu, X } from "lucide-react";
import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";

const routes = [
	{ href: "/", label: "Home" },
	{ href: "/about", label: "About" },
	{ href: "/learn-more", label: "Learn More" },
	{ href: "/sponsor", label: "Sponsor" },
	{ href: "/contact", label: "Contact" },
];

export function Navigation() {
	const [isOpen, setIsOpen] = useState(false);
	const pathname = usePathname();

	return (
		<header className="fixed top-0 left-0 right-0 z-50 bg-background/60 backdrop-blur-md border-b border-primary/10">
			<nav className="container mx-auto px-4">
				<div className="flex items-center justify-between h-16">
					<Link href="/" className="relative flex items-center gap-2">
						<div className="relative w-8 h-8">
							<Image
								src="/logob3.png"
								alt="B3Nature Logo"
								fill
								className="object-contain"
								priority
							/>
						</div>
						<span className="text-2xl font-bold text-primary relative z-10">
							B3Nature
						</span>
					</Link>

					{/* Desktop Navigation */}
					<div className="hidden md:flex items-center space-x-8">
						{routes.map((route) => (
							<Link
								key={route.href}
								href={route.href}
								className={`text-sm font-medium transition-colors hover:text-primary ${
									pathname === route.href
										? "text-primary"
										: "text-foreground/80"
								}`}
							>
								{route.label}
							</Link>
						))}
					</div>

					{/* Mobile Menu Button */}
					<Button
						variant="ghost"
						className="md:hidden"
						onClick={() => setIsOpen(!isOpen)}
					>
						<span className="sr-only">Toggle menu</span>
						{isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
					</Button>
				</div>

				{/* Mobile Navigation */}
				{isOpen && (
					<div className="md:hidden py-4">
						{routes.map((route) => (
							<Link
								key={route.href}
								href={route.href}
								className={`block py-2 text-sm font-medium transition-colors hover:text-primary ${
									pathname === route.href
										? "text-primary"
										: "text-foreground/80"
								}`}
								onClick={() => setIsOpen(false)}
							>
								{route.label}
							</Link>
						))}
					</div>
				)}
			</nav>
		</header>
	);
}

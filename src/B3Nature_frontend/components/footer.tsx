import { Github, Linkedin, Mail, MessageCircle } from "lucide-react";
import Link from "next/link";

export function Footer() {
	return (
		<footer className="bg-background border-t border-primary/20">
			<div className="container mx-auto px-4 py-8">
				<div className="grid grid-cols-1 md:grid-cols-3 gap-8">
					<div>
						<h3 className="text-xl font-bold text-primary mb-4">B3Nature</h3>
						<p className="text-gray-400">
							Bridging the gap between nature and technology through innovative
							solutions.
						</p>
					</div>
					<div>
						<h3 className="text-xl font-bold text-primary mb-4">Quick Links</h3>
						<ul className="space-y-2">
							<li>
								<Link
									href="/about"
									className="text-gray-400 hover:text-primary"
								>
									About
								</Link>
							</li>
							<li>
								<Link
									href="/learn-more"
									className="text-gray-400 hover:text-primary"
								>
									Learn More
								</Link>
							</li>
							<li>
								<Link
									href="/sponsor"
									className="text-gray-400 hover:text-primary"
								>
									Sponsor
								</Link>
							</li>
							<li>
								<Link
									href="/contact"
									className="text-gray-400 hover:text-primary"
								>
									Contact
								</Link>
							</li>
						</ul>
					</div>
					<div>
						<h3 className="text-xl font-bold text-primary mb-4">Connect</h3>
						<div className="flex space-x-4">
							<Link
								href="mailto:info.B3Nature@gmail.com"
								className="text-gray-400 hover:text-primary"
							>
								<Mail className="h-6 w-6" />
							</Link>
							<Link
								href="https://github.com/b3pay"
								target="_blank"
								className="text-gray-400 hover:text-primary"
							>
								<Github className="h-6 w-6" />
							</Link>
							<Link
								href="https://www.linkedin.com/in/bahamin-dehpour-deylami/"
								target="_blank"
								className="text-gray-400 hover:text-primary"
							>
								<Linkedin className="h-6 w-6" />
							</Link>
							<div className="text-gray-400">
								<MessageCircle className="h-6 w-6" />
							</div>
						</div>
					</div>
				</div>
				<div className="mt-8 pt-8 border-t border-primary/20 text-center text-gray-400">
					<p>
						&copy; {new Date().getFullYear()} B3Nature. All rights reserved.
					</p>
				</div>
			</div>
		</footer>
	);
}

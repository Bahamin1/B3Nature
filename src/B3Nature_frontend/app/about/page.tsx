import { Card, CardContent } from "@/components/ui/card";
import Image from "next/image";

export default function AboutPage() {
	return (
		<div className="pt-16">
			<section className="relative py-20 overflow-hidden">
				<div className="absolute inset-0 opacity-20">
					<Image
						src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Flux_Dev_Create_an_image_where_nature_and_technology_are_artis_3-m4tBnSDesXO8bKuzadRLpntJzEw5ve.jpeg"
						alt="Background"
						fill
						className="object-cover"
					/>
				</div>
				<div className="container mx-auto px-4 relative">
					<h1 className="text-5xl font-bold mb-8 text-center">
						About B3Nature
					</h1>
					<div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
						<Card className="bg-card-gradient border-primary/20">
							<CardContent className="p-6">
								<h2 className="text-2xl font-semibold mb-4 text-primary">
									Our Story
								</h2>
								<p className="text-black-300">
									B3Nature emerged from a vision to create harmony between
									technological advancement and environmental preservation. We
									believe that innovation should not come at the cost of our
									planet's well-being.
								</p>
							</CardContent>
						</Card>
						<Card className="bg-card-gradient border-primary/20">
							<CardContent className="p-6">
								<h2 className="text-2xl font-semibold mb-4 text-primary">
									Our Values
								</h2>
								<ul className="text-black-900 space-y-2">
									<li>• Environmental Consciousness</li>
									<li>• Technological Innovation</li>
									<li>• Sustainable Development</li>
									<li>• Community Collaboration</li>
								</ul>
							</CardContent>
						</Card>
					</div>
				</div>
			</section>

			<section className="py-20 bg-background">
				<div className="container mx-auto px-4">
					<h2 className="text-4xl font-bold mb-12 text-center">Our Approach</h2>
					<div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
						<Card className="bg-card-gradient border-primary/20">
							<CardContent className="p-6">
								<h3 className="text-xl font-semibold mb-4 text-primary">
									Research
								</h3>
								<p className="text-black-300">
									Conducting thorough research to understand environmental
									challenges and identify technological solutions.
								</p>
							</CardContent>
						</Card>
						<Card className="bg-card-gradient border-primary/20">
							<CardContent className="p-6">
								<h3 className="text-xl font-semibold mb-4 text-primary">
									Development
								</h3>
								<p className="text-black-300">
									Creating innovative solutions that bridge the gap between
									nature and technology.
								</p>
							</CardContent>
						</Card>
						<Card className="bg-card-gradient border-primary/20">
							<CardContent className="p-6">
								<h3 className="text-xl font-semibold mb-4 text-primary">
									Implementation
								</h3>
								<p className="text-black-300">
									Deploying sustainable solutions that make a positive impact on
									both technology and nature.
								</p>
							</CardContent>
						</Card>
					</div>
				</div>
			</section>
		</div>
	);
}

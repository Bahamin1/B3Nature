import { Button } from "@/components/ui/button";
import Image from "next/image";
import Link from "next/link";

export default function Home() {
	return (
		<div className="relative min-h-screen flex items-center justify-center bg-gradient-to-b from-primary/5 via-background/50 to-secondary/5">
			<div className="absolute inset-0 z-0">
				<Image
					src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Flux_Dev_Create_an_image_where_nature_and_technology_are_artis_3-m4tBnSDesXO8bKuzadRLpntJzEw5ve.jpeg"
					alt="B3Nature Hero Background"
					fill
					className="object-cover opacity-20"
					priority
				/>
			</div>
			<div className="relative z-10 text-center p-6">
				<div className="relative inline-block">
					<Image
						src="/logob3.png"
						alt="B3Nature Logo"
						width={200}
						height={200}
						className="mx-auto mb-6 opacity-90"
						priority
					/>
				</div>
				<h1 className="text-5xl md:text-7xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-primary to-secondary">
					B3Nature
				</h1>
				<p className="text-xl md:text-2xl mb-8 max-w-2xl mx-auto text-foreground/90 font-medium">
					Bridging the gap between nature and technology through innovative
					solutions
				</p>
				<div className="flex flex-wrap gap-4 justify-center">
					<Button
						asChild
						size="lg"
						className="bg-primary/90 hover:bg-primary text-primary-foreground backdrop-blur-sm"
					>
						<Link href="/about">Learn More</Link>
					</Button>
					<Button
						asChild
						size="lg"
						variant="outline"
						className="border-primary/50 text-primary hover:bg-primary/10 backdrop-blur-sm"
					>
						<Link href="/sponsor">Become a Sponsor</Link>
					</Button>
				</div>
			</div>
		</div>
	);
}

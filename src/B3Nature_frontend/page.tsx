import { Github, Linkedin, Mail, MessageCircle } from "lucide-react"
import Image from "next/image"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"

export default function Home() {
  return (
    <div className="min-h-screen bg-background text-white">
      {/* Hero Section */}
      <section className="relative h-screen flex items-center justify-center overflow-hidden">
        <div className="absolute inset-0">
          <Image
            src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Flux_Dev_Create_an_image_where_nature_and_technology_are_artis_3-m4tBnSDesXO8bKuzadRLpntJzEw5ve.jpeg"
            alt="B3Nature Hero Background"
            fill
            className="object-cover opacity-40"
            priority
          />
        </div>
        <div className="relative z-10 container mx-auto px-4 text-center">
          <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
            B3Nature
          </h1>
          <p className="text-xl md:text-2xl mb-8 max-w-2xl mx-auto">
            Bridging the gap between nature and technology through innovative solutions
          </p>
          <div className="flex flex-wrap gap-4 justify-center">
            <Button asChild className="bg-primary hover:bg-primary/90">
              <Link href="#about">Learn More</Link>
            </Button>
            <Button asChild variant="outline" className="border-primary text-primary hover:bg-primary/10">
              <Link href="#sponsor">Become a Sponsor</Link>
            </Button>
          </div>
        </div>
      </section>

      {/* About Section */}
      <section id="about" className="py-20 bg-background/95">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">About the Project</h2>
          <div className="grid md:grid-cols-2 gap-8">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h3 className="text-2xl font-semibold mb-4 text-primary">Vision</h3>
                <p className="text-gray-300">
                  B3Nature is an innovative project that aims to harmonize technology with nature, creating sustainable
                  solutions for a better future. Our approach combines cutting-edge technology with environmental
                  consciousness.
                </p>
              </CardContent>
            </Card>
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h3 className="text-2xl font-semibold mb-4 text-primary">Mission</h3>
                <p className="text-gray-300">
                  We're dedicated to developing eco-friendly technologies that promote sustainability while advancing
                  technological capabilities. Join us in our mission to create a more sustainable and technologically
                  advanced world.
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* GitHub Section */}
      <section className="py-20 bg-gradient-to-b from-background/95 to-background">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">Project Repository</h2>
          <Card className="bg-card-gradient border-primary/20 max-w-3xl mx-auto">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-2xl font-semibold text-primary">B3Nature</h3>
                <Button asChild variant="outline" className="border-primary text-primary hover:bg-primary/10">
                  <Link href="https://github.com/Bahamin1/B3Nature" target="_blank">
                    <Github className="mr-2 h-4 w-4" />
                    View Repository
                  </Link>
                </Button>
              </div>
              <p className="text-gray-300 mb-4">
                Explore our open-source codebase and contribute to the development of B3Nature. We welcome collaborators
                who share our vision for a sustainable future.
              </p>
            </CardContent>
          </Card>
        </div>
      </section>

      {/* Sponsor Section */}
      <section id="sponsor" className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">Support the Project</h2>
          <div className="max-w-3xl mx-auto text-center">
            <p className="text-xl text-gray-300 mb-8">
              Help us bring B3Nature to life! We're seeking sponsors who believe in our vision of harmonizing technology
              with nature. Your support will accelerate the development of sustainable solutions for a better tomorrow.
            </p>
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h3 className="text-2xl font-semibold mb-6 text-primary">Connect With Us</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <Link
                    href="mailto:Bahamindehpour@gmail.com"
                    className="flex items-center justify-center gap-2 p-3 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Mail className="h-5 w-5" />
                    <span>Email</span>
                  </Link>
                  <Link
                    href="https://github.com/Bahamin1"
                    target="_blank"
                    className="flex items-center justify-center gap-2 p-3 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Github className="h-5 w-5" />
                    <span>GitHub</span>
                  </Link>
                  <Link
                    href="https://www.linkedin.com/in/bahamin-dehpour-deylami/"
                    target="_blank"
                    className="flex items-center justify-center gap-2 p-3 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Linkedin className="h-5 w-5" />
                    <span>LinkedIn</span>
                  </Link>
                  <div className="flex items-center justify-center gap-2 p-3 rounded-lg bg-primary/10">
                    <MessageCircle className="h-5 w-5" />
                    <span>Discord: Bahamin</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 bg-background border-t border-primary/20">
        <div className="container mx-auto px-4 text-center text-gray-400">
          <p>&copy; {new Date().getFullYear()} B3Nature. All rights reserved.</p>
        </div>
      </footer>
    </div>
  )
}


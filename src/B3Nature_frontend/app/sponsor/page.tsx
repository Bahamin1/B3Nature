import Image from "next/image"
import Link from "next/link"
import { Github, Linkedin, Mail, MessageCircle } from "lucide-react"
import { Card, CardContent } from "@/components/ui/card"

export default function SponsorPage() {
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
          <h1 className="text-5xl font-bold mb-8 text-center">Sponsor B3Nature</h1>
          <div className="max-w-4xl mx-auto">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h2 className="text-2xl font-semibold mb-4 text-primary">Why Sponsor?</h2>
                <p className="text-gray-300 mb-6">
                  By sponsoring B3Nature, you're investing in a sustainable future where technology and nature coexist
                  harmoniously. Your support will help accelerate the development of innovative solutions that address
                  environmental challenges.
                </p>
                <div className="space-y-4">
                  <h3 className="text-xl font-semibold text-primary">Benefits of Sponsorship</h3>
                  <ul className="list-disc list-inside text-gray-300 space-y-2">
                    <li>Early access to project developments</li>
                    <li>Recognition in project documentation</li>
                    <li>Direct collaboration opportunities</li>
                    <li>Influence on project direction</li>
                  </ul>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">Contact Information</h2>
          <div className="max-w-3xl mx-auto">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <Link
                    href="mailto:Bahamindehpour@gmail.com"
                    className="flex items-center gap-3 p-4 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Mail className="h-6 w-6" />
                    <div>
                      <h3 className="font-semibold">Email</h3>
                      <p className="text-sm text-gray-300">Bahamindehpour@gmail.com</p>
                    </div>
                  </Link>
                  <Link
                    href="https://github.com/Bahamin1"
                    target="_blank"
                    className="flex items-center gap-3 p-4 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Github className="h-6 w-6" />
                    <div>
                      <h3 className="font-semibold">GitHub</h3>
                      <p className="text-sm text-gray-300">Bahamin1</p>
                    </div>
                  </Link>
                  <Link
                    href="https://www.linkedin.com/in/bahamin-dehpour-deylami/"
                    target="_blank"
                    className="flex items-center gap-3 p-4 rounded-lg bg-primary/10 hover:bg-primary/20 transition-colors"
                  >
                    <Linkedin className="h-6 w-6" />
                    <div>
                      <h3 className="font-semibold">LinkedIn</h3>
                      <p className="text-sm text-gray-300">Bahamin Dehpour Deylami</p>
                    </div>
                  </Link>
                  <div className="flex items-center gap-3 p-4 rounded-lg bg-primary/10">
                    <MessageCircle className="h-6 w-6" />
                    <div>
                      <h3 className="font-semibold">Discord</h3>
                      <p className="text-sm text-gray-300">Bahamin</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>
    </div>
  )
}


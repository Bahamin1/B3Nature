import Image from "next/image"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"

export default function LearnMorePage() {
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
          <h1 className="text-5xl font-bold mb-8 text-center">Learn More</h1>
          <div className="max-w-4xl mx-auto">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h2 className="text-2xl font-semibold mb-4 text-primary">Project Overview</h2>
                <p className="text-gray-300 mb-6">
                  B3Nature is an innovative initiative that aims to create sustainable solutions by harmonizing
                  technology with nature. Our project focuses on developing eco-friendly technologies that promote
                  environmental consciousness while advancing technological capabilities.
                </p>
                <div className="space-y-4">
                  <h3 className="text-xl font-semibold text-primary">Key Features</h3>
                  <ul className="list-disc list-inside text-gray-300 space-y-2">
                    <li>Sustainable Technology Integration</li>
                    <li>Environmental Impact Analysis</li>
                    <li>Open Source Development</li>
                    <li>Community-Driven Innovation</li>
                  </ul>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      <section className="py-20 bg-background">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">Technical Details</h2>
          <div className="grid md:grid-cols-2 gap-8 max-w-5xl mx-auto">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h3 className="text-2xl font-semibold mb-4 text-primary">Technology Stack</h3>
                <ul className="text-gray-300 space-y-2">
                  <li>• Advanced Algorithms</li>
                  <li>• Data Analytics</li>
                  <li>• Machine Learning</li>
                  <li>• Environmental Sensors</li>
                </ul>
              </CardContent>
            </Card>
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <h3 className="text-2xl font-semibold mb-4 text-primary">Implementation</h3>
                <ul className="text-gray-300 space-y-2">
                  <li>• Modular Architecture</li>
                  <li>• Scalable Solutions</li>
                  <li>• Real-time Monitoring</li>
                  <li>• Sustainable Practices</li>
                </ul>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      <section className="py-20 bg-background/95">
        <div className="container mx-auto px-4">
          <h2 className="text-4xl font-bold mb-12 text-center">Get Involved</h2>
          <div className="max-w-3xl mx-auto text-center">
            <p className="text-xl text-gray-300 mb-8">
              Join us in our mission to create a more sustainable and technologically advanced future. There are many
              ways to contribute to the B3Nature project.
            </p>
            <div className="flex flex-wrap justify-center gap-4">
              <Button asChild className="bg-primary hover:bg-primary/90">
                <Link href="/sponsor">Become a Sponsor</Link>
              </Button>
              <Button asChild variant="outline" className="border-primary text-primary hover:bg-primary/10">
                <Link href="https://github.com/Bahamin1/B3Nature" target="_blank">
                  View on GitHub
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </section>
    </div>
  )
}


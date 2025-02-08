import { Heart } from "lucide-react"

export default function SponsorshipSection() {
  return (
    <section className="bg-green-50 py-16">
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold mb-8 text-center">Sponsor B3Nature</h2>
        <div className="max-w-3xl mx-auto text-center">
          <p className="text-lg mb-8">
            Help us complete the B3Nature project and make a lasting impact on the environment. Your sponsorship will
            directly contribute to the development of innovative solutions that bridge the gap between technology and
            nature.
          </p>
          <p className="text-lg mb-8">
            By becoming a sponsor, you'll be at the forefront of sustainable technology, gaining early access to our
            developments and the opportunity to shape the future of environmental conservation.
          </p>
          <a
            href="#"
            className="inline-flex items-center bg-green-600 text-white font-bold py-3 px-6 rounded-full transition duration-300 ease-in-out hover:bg-green-700"
          >
            <Heart className="mr-2" /> Become a Sponsor
          </a>
        </div>
      </div>
    </section>
  )
}


import Header from "./components/Header"
import Footer from "./components/Footer"
import RepositoryCard from "./components/RepositoryCard"
import SponsorshipSection from "./components/SponsorshipSection"
import { ArrowRight } from "lucide-react"

export default function Home() {
  // Placeholder data for repositories
  const repositories = [
    { name: "B3Nature", description: "Main repository for the B3Nature project", stars: 42 },
    { name: "B3Nature-Core", description: "Core functionality for B3Nature", stars: 28 },
    { name: "B3Nature-Docs", description: "Documentation for the B3Nature project", stars: 15 },
  ]

  return (
    <div className="flex flex-col min-h-screen">
      <Header />
      <main className="flex-grow">
        <section className="bg-gradient-to-r from-green-400 to-blue-500 text-white py-20">
          <div className="container mx-auto px-4">
            <h1 className="text-4xl md:text-6xl font-bold mb-4">Welcome to B3Nature</h1>
            <p className="text-xl md:text-2xl mb-8">Revolutionizing the way we interact with nature</p>
            <a
              href="#learn-more"
              className="inline-flex items-center bg-white text-green-600 font-bold py-2 px-4 rounded-full transition duration-300 ease-in-out hover:bg-green-100"
            >
              Learn More <ArrowRight className="ml-2" />
            </a>
          </div>
        </section>

        <section id="learn-more" className="py-16">
          <div className="container mx-auto px-4">
            <h2 className="text-3xl font-bold mb-8 text-center">About B3Nature</h2>
            <p className="text-lg mb-8 max-w-3xl mx-auto text-center">
              B3Nature is an innovative project aimed at bridging the gap between technology and nature. Our mission is
              to create sustainable solutions that enhance our connection with the environment while leveraging
              cutting-edge technology.
            </p>
          </div>
        </section>

        <section className="bg-gray-100 py-16">
          <div className="container mx-auto px-4">
            <h2 className="text-3xl font-bold mb-8 text-center">Our GitHub Repositories</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {repositories.map((repo) => (
                <RepositoryCard key={repo.name} {...repo} />
              ))}
            </div>
          </div>
        </section>

        <SponsorshipSection />
      </main>
      <Footer />
    </div>
  )
}


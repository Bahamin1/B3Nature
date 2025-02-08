import { Github, Twitter, Linkedin } from "lucide-react"

export default function Footer() {
  return (
    <footer className="bg-gray-800 text-white py-8">
      <div className="container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="mb-4 md:mb-0">
            <p>&copy; 2023 B3Nature. All rights reserved.</p>
          </div>
          <div className="flex space-x-4">
            <a
              href="https://github.com/Bahamin1/B3Nature"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-green-400"
            >
              <Github className="h-6 w-6" />
            </a>
            <a href="#" className="hover:text-green-400">
              <Twitter className="h-6 w-6" />
            </a>
            <a href="#" className="hover:text-green-400">
              <Linkedin className="h-6 w-6" />
            </a>
          </div>
        </div>
      </div>
    </footer>
  )
}


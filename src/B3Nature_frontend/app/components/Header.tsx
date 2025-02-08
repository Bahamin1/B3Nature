import Link from "next/link"
import { Leaf } from "lucide-react"

export default function Header() {
  return (
    <header className="bg-white shadow-sm">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <Link href="/" className="flex items-center">
            <Leaf className="h-8 w-8 text-green-600 mr-2" />
            <span className="text-xl font-bold text-gray-800">B3Nature</span>
          </Link>
          <nav>
            <ul className="flex space-x-4">
              <li>
                <Link href="#" className="text-gray-600 hover:text-green-600">
                  About
                </Link>
              </li>
              <li>
                <Link href="#" className="text-gray-600 hover:text-green-600">
                  Repositories
                </Link>
              </li>
              <li>
                <Link href="#" className="text-gray-600 hover:text-green-600">
                  Sponsor
                </Link>
              </li>
              <li>
                <Link href="#" className="text-gray-600 hover:text-green-600">
                  Contact
                </Link>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </header>
  )
}


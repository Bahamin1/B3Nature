import { Star, GitFork } from "lucide-react"

interface RepositoryCardProps {
  name: string
  description: string
  stars: number
}

export default function RepositoryCard({ name, description, stars }: RepositoryCardProps) {
  return (
    <div className="bg-white rounded-lg shadow-md p-6 transition duration-300 ease-in-out transform hover:-translate-y-1 hover:shadow-lg">
      <h3 className="text-xl font-semibold mb-2">{name}</h3>
      <p className="text-gray-600 mb-4">{description}</p>
      <div className="flex items-center text-gray-500">
        <Star className="h-4 w-4 mr-1" />
        <span className="mr-4">{stars}</span>
        <GitFork className="h-4 w-4 mr-1" />
        <span>Fork</span>
      </div>
    </div>
  )
}


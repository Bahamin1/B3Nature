"use client"

import { useState } from "react"
import Image from "next/image"
import { Loader2 } from "lucide-react"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { useToast } from "@/components/ui/use-toast"
import { sendEmail } from "../actions/send-email"

export default function ContactPage() {
  const [isPending, setIsPending] = useState(false)
  const { toast } = useToast()

  async function handleSubmit(formData: FormData) {
    setIsPending(true)
    try {
      const result = await sendEmail(formData)

      if (result.error) {
        toast({
          variant: "destructive",
          title: "Error",
          description: result.error,
        })
        return
      }

      toast({
        title: "Success",
        description: "Your message has been sent successfully!",
      })

      // Reset the form
      const form = document.querySelector("form") as HTMLFormElement
      form.reset()
    } catch (error) {
      console.error("Unexpected error:", error)
      toast({
        variant: "destructive",
        title: "Error",
        description: "An unexpected error occurred. Please try again later.",
      })
    } finally {
      setIsPending(false)
    }
  }

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
          <h1 className="text-5xl font-bold mb-8 text-center">Contact Us</h1>
          <div className="max-w-2xl mx-auto">
            <Card className="bg-card-gradient border-primary/20">
              <CardContent className="p-6">
                <form action={handleSubmit} className="space-y-6">
                  <div className="space-y-2">
                    <label htmlFor="name" className="text-sm font-medium">
                      Name
                    </label>
                    <Input id="name" name="name" placeholder="Your name" className="bg-background/50" required />
                  </div>
                  <div className="space-y-2">
                    <label htmlFor="email" className="text-sm font-medium">
                      Email
                    </label>
                    <Input
                      id="email"
                      name="email"
                      type="email"
                      placeholder="Your email"
                      className="bg-background/50"
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <label htmlFor="message" className="text-sm font-medium">
                      Message
                    </label>
                    <Textarea
                      id="message"
                      name="message"
                      placeholder="Your message"
                      className="bg-background/50"
                      rows={6}
                      required
                    />
                  </div>
                  <Button type="submit" className="w-full bg-primary hover:bg-primary/90" disabled={isPending}>
                    {isPending ? (
                      <>
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        Sending...
                      </>
                    ) : (
                      "Send Message"
                    )}
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>
    </div>
  )
}


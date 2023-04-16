// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import type { NextApiRequest, NextApiResponse } from "next";
import blogs from "@/src/exampleData/blogpost.json";
import { BlogPost } from "@/src/types/BlogPost";

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<{ posts: BlogPost[] }>
) {
  res.status(200).json(blogs);
}

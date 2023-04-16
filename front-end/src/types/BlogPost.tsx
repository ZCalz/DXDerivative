export type BlogPost = {
    id: number;
    title: string;
    excerpt: string;
    image: string;
    author: {
        name: string;
        avatar: string;
    }
    date: string;
    content: string;
}
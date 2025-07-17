import { MusicData } from "./MusicDataModel";

export interface MusicListData {
  list_id: string;
  list_title: string;
  list_user_name: string;
  list_user_img: string;
  list_introduce: string;
  list_share: number;
  list_comments: number;
  list_collection: number;
  list_img: string;
  list_music: MusicData[]
}


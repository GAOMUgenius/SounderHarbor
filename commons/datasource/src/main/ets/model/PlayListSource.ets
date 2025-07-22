import { APPConstants } from "../../../../Index";
import { BasicDataSource } from "../datasource/BasicDataSource";
import { MusicData } from "./MusicDataModel";
import { emitter, Callback } from '@kit.BasicServicesKit';

@ObservedV2
export class PlayListSource extends BasicDataSource {
  @Trace private list: MusicData[] = [];

  constructor(list: MusicData[]) {
    super();
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): MusicData {
    return this.list[index];
  }

  getList(): MusicData[] {
    return this.list
  }

  getIndex(id: string): number {
    // 边界判断：如果数组为空，直接返回-1
    if (!this.list || this.list.length === 0) {
      return -1;
    }
    // 使用findIndex遍历数组，找到id匹配的元素下标
    return this.list.findIndex(item => {
      // 确保item存在且有id属性（避免空指针错误）
      return item && item.id === id;
    });
  }

  addMusic(newMusic: MusicData) {
    this.list.unshift(newMusic)
    // 发送事件
    const event: emitter.InnerEvent = {
      eventId: APPConstants.PLAYLIST_CHANGED_EVENT_ID,
      priority: emitter.EventPriority.LOW
    };

    const eventData: emitter.EventData = {
      data: {
        action: "add",
        item: newMusic,
        totalCount: this.list.length
      }
    };

    emitter.emit(event, eventData);
    this.notifyDataReload();
  }

  removeMusic(id: string) {
    const index = this.list.findIndex(item => item.id === id);
    if (index !== -1) {
      const removed = this.list.splice(index, 1)[0];

      // 发送事件
      const event: emitter.InnerEvent = {
        eventId: APPConstants.PLAYLIST_CHANGED_EVENT_ID,
        priority: emitter.EventPriority.LOW
      };

      const eventData: emitter.EventData = {
        data: {
          action: "remove",
          item: removed,
          totalCount: this.list.length
        }
      };

      emitter.emit(event, eventData);
    }
    this.notifyDataReload();
  }
}

export interface PlaylistChangeEventData {
  action: 'add' | 'remove';
  item: MusicData;
  totalCount: number;
}
;

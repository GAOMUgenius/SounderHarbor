/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { CardInfo } from "../model/PlayListModel";


export default class Constants {
  /**
   * Unit length of the card, which is used to set the card proportion.
   */
  static readonly CARD_UNIT_LENGTH: number = 120;
  /**
   * Card list test case.
   */
  static readonly CARD_TEST_CASE: CardInfo[] = [
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/play_card_empty.svg',
      width: 240,
      height: 300,
      scale: 1
    },
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/87c9654a7b9d0392b3f4615fc6b47ba.jpg',
      width: 240,
      height: 300,
      scale: 1
    },
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/f6d117e0feee6d0613d47acd72946eb.jpg',
      width: 240,
      height: 300,
      scale: 1
    },
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/aa4b8ac29bb3737218d721f63b1c189.jpg',
      width: 240,
      height: 300,
      scale: 1
    },
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/780775ec4490bc2a83655fa8f655bc8.jpg',
      width: 240,
      height: 300,
      scale: 1
    },
    {
      src: 'https://gitee.com/gomugenius/SoundHarbor_Picture/raw/master/img/play_card_empty.svg',
      width: 240,
      height: 300,
      scale: 1
    }

  ];
}
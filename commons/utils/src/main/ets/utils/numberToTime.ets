export function numberToTime(number: number) {
  if (number > 60 * 1000) {
    const s = Math.floor(number / 1000 % 60)
    const m = Math.floor(number / 1000 / 60)
    const second = s.toString().padStart(2, '0')
    const minute = m.toString().padStart(2, '0')
    return minute + ':' + second
  } else {
    const s = Math.floor(number / 1000 % 60)
    const second = s.toString().padStart(2, '0')
    return '00:' + second
  }
}
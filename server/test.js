var exampleTime = new Date();
const timestamps = [];
var exampleIntakeHours = 8;
var exampleIntakeTimes = 4;
var matchedTimestamp = null;

for (let i = 1; i <= exampleIntakeTimes; i++) {
  var expiryDate = new Date(new Date().setMinutes(new Date().getMinutes() + i));
  expiryDate.setMilliseconds(0);
  timestamps.push(expiryDate);
}

console.log(exampleTime);
console.log(timestamps);

while (true) {
  var currentIntakeTime = exampleIntakeTimes;
  var currentTime = new Date();
  currentTime.setMilliseconds(0);
  for (let i = 0; i < timestamps.length; i++) {
    if (currentTime.getTime() === timestamps[i].getTime()) {
      matchedTimestamp = timestamps.pop(timestamps[i]);
      console.log("Last matched timestamp: ", matchedTimestamp);
      currentIntakeTime -= 1;
      multiplier = exampleIntakeTimes - currentIntakeTime
      var correctDate = new Date(exampleTime.setHours(exampleTime.getHours() + exampleIntakeHours));
      correctDate.setMilliseconds(0);
      console.log("Correct timestamp: ", correctDate)
      break;
    }
  }
}


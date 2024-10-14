export function getRandomElements(arr, num) {
    // Create a new array to store the random elements
    const randomElements = [];

    // Create a copy of the original array to avoid mutating it
    const copy = [...arr];

    // Ensure num does not exceed the length of the array
    num = Math.min(num, copy.length);

    for (let i = 0; i < num; i++) {
        // Generate a random index
        const randomIndex = Math.floor(Math.random() * copy.length);
        // Push the random element to the new array
        randomElements.push(copy[randomIndex]);
        // Remove the selected element from the copy to ensure uniqueness
        copy.splice(randomIndex, 1);
    }

    return randomElements;
}

export function shuffleArray(array) {
    // Create a shallow copy of the array using slice() or spread operator
    const newArray = [...array]; // Or you can use array.slice()

    for (let i = newArray.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [newArray[i], newArray[j]] = [newArray[j], newArray[i]];
    }
    return newArray;
}

document.addEventListener('DOMContentLoaded', function() {
    const keys = document.querySelectorAll('.keyboard-key');
    const gridTiles = document.querySelectorAll('.wordle-tile');
    const guessInput = document.querySelector('input[name="guess"]'); // Get the guess input field
    const submitButton = document.querySelector('input[type="submit"]'); // Get the submit button for the form
    let currentTileIndex = 0;
    let currentRow = 0;

    // On-screen keyboard click
    keys.forEach(key => {
      key.addEventListener('click', (event) => {
        const keyPressed = event.target.getAttribute('data-key');
        handleKeyPress(keyPressed);
      });
    });

    // Physical keyboard press
    document.addEventListener('keydown', (event) => {
      const keyPressed = event.key.toUpperCase();
      if (/^[A-Z]$/.test(keyPressed) || keyPressed === 'ENTER' || keyPressed === 'BACKSPACE') {
        handleKeyPress(keyPressed);
      }
    });

    function handleKeyPress(key) {
        console.log(`Key pressed: ${key}`); // Debugging log for keypresses
        if (key === 'ENTER') {
          if (currentTileIndex % 5 === 0) {
            submitGuess(); // Trigger guess submission when 'ENTER' is pressed
          }
        } else if (key === 'BACKSPACE') {
          deleteLastLetter(); // Handle backspace for deleting letters
        } else if (/^[A-Z]$/.test(key)) {
          addLetterToTile(key); // Add letters to the tile
        }
        simulateKeyPress(key); // Visual feedback for keypress
      }

    function addLetterToTile(letter) {
      if (currentTileIndex < (currentRow + 1) * 5) {
        gridTiles[currentTileIndex].textContent = letter; // Display letter in the tile
        currentTileIndex++;
        guessInput.value += letter; // Update the input field value with the letter
      }
    }

    function deleteLastLetter() {
      if (currentTileIndex > currentRow * 5) {
        currentTileIndex--;
        gridTiles[currentTileIndex].textContent = ''; // Clear the tile
        guessInput.value = guessInput.value.slice(0, -1); // Remove last character from the input field
      }
    }

    function submitGuess() {
        if (guessInput.value.length === 5) {
          console.log('Submitting guess via ENTER key...');
          submitButton.click(); // Simulate form submission by clicking the submit button
        } else {
          console.log('Guess is not 5 letters long, cannot submit.');
        }
    }

    function simulateKeyPress(key) {
      const keyButton = document.querySelector(`.keyboard-key[data-key="${key}"]`);
      if (keyButton) {
        keyButton.setAttribute('data-pressed', 'true');
        setTimeout(() => {
          keyButton.removeAttribute('data-pressed');
        }, 1000);
      }
    }
});

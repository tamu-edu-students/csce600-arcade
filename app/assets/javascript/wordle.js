document.addEventListener('DOMContentLoaded', function() {
    const keys = document.querySelectorAll('.keyboard-key');
    const gridTiles = document.querySelectorAll('.wordle-tile');
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
      if (key === 'ENTER') {
        if (currentTileIndex % 5 === 0) {
          submitGuess();
        }
      } else if (key === 'BACKSPACE') {
        deleteLastLetter();
      } else if (/^[A-Z]$/.test(key)) {
        addLetterToTile(key);
      }
      simulateKeyPress(key);
    }

    function addLetterToTile(letter) {
      if (currentTileIndex < (currentRow + 1) * 5) {
        gridTiles[currentTileIndex].textContent = letter;
        currentTileIndex++;
      }
    }

    function deleteLastLetter() {
      if (currentTileIndex > currentRow * 5) {
        currentTileIndex--;
        gridTiles[currentTileIndex].textContent = '';
      }
    }

    function submitGuess() {
      const guess = collectGuess();
      if (guess.length === 5) {
        // Send guess to the controller via AJAX
        fetch('/wordles/submit_guess', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ guess: guess })
        })
        .then(response => response.json())
        .then(data => {
          if (data.errors.length === 0) {
            updateGrid(data.results);
            currentRow++;
          } else {
            alert("Error: " + data.errors.join(', '));
          }
        });
      }
    }

    function collectGuess() {
      let guess = '';
      for (let i = 0; i < 5; i++) {
        guess += gridTiles[currentRow * 5 + i].textContent;
      }
      return guess;
    }

    function updateGrid(results) {
      // Update the grid with color based on the result
      Object.keys(results).forEach((letter, index) => {
        const tile = gridTiles[currentRow * 5 + index];
        tile.classList.add(results[letter]); // Add class 'green', 'yellow', or 'grey'
      });
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

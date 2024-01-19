# CafeRadar

 An app that helps users find empty spots in cafes or libraries

## How to clone and run the app

1. Clone the repository:
    ```bash
    git clone git@github.com:CafeSpot/CafeRadar.git
    ```

2. Change to the project directory:
    ```bash
    cd CafeRadar
    ```

3. Install the required dependencies:
    ```bash
    pip install -r requirements.txt
    pip install pydantic[email]
    ```

4. Run the app using uvicorn:
    ```bash
    uvicorn src.backend.main:app -- reload
    ```

5. View the result in your browser at [http://127.0.0.1:8000](http://127.0.0.1:8000)

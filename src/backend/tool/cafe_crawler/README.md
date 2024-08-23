# Tool - CAFE_CRAWLER
* [Function]: there are three main functions in this tool
    1. Fetch the cafe's ID from Google map service with keywords
        * Usage: flag ```-id```
        * You can set the key keyword in ```/resource/cafe_keyword.json```.
            * NOTE: The format is "{city}{district}{village}+{class}" now. For example, 新竹市東區東香里咖啡廳
        * The result is the list of string. It would be saved at ```/resource/cafe_place_ids.json```
    2. Fetch the cafe's detail infos from Google map service with cafe's ID
        * Usage: flag ```-detail```&```-detail_limit INT```(optional)
            * NOTE: This function incurs an API cost. To prevent abuse, the default usage limit per program run is set to 5. To manually increase this limit, use the ```-detail_limit``` flag followed by the desired value.
        * The result is dictionary which uses cafe's ID as key. The structure of value can be found at ```/resource/cafe_detail_format.json```
        * The result would be saved at ```/resource/cafe_place_details.json```
    3. Push the cafe's details from second function to DB
        * Usage: flag ```-push_db```
* [ENV_Setting]
    1. Command in shell: ```pip install -r requirements.txt```
    2. Add the env var to the .env file, required term:
        * MONGODB_URL
        * GOOGLE_API_KEY
* [Runing]
    1. Update cafe's ID list: ```python crawler.py -id```
    2. Update cafe's Detail list: ```python crawler.py -detail -detail_limit [times]```
    3. Push the cafe's Detail to DB: ```python crawler.py -push_db```
    4. all: ```python crawler.py -id -detail -detail_limit [times] -push_db```
* [Development]
    1. Each time the program starts, the files ```./resource/cafe_place_ids.json``` and ```./resource/cafe_place_details.json``` are loaded if they exist.
    2. The cafes in ```cafe_place_details.json``` are a subset of those in ```cafe_place_ids.json``` because the data in ```cafe_place_details.json``` was fetched using the information from ```cafe_place_ids.json```
    3. There is a design check for duplicate operations before fetching detailed information to prevent unnecessary costs.

* [Record]
    1. 2024/8/24
        1. Complete this file and finalize the program.
        2. Retrieve information for 1,173 cafes around the entire Hsinchu City using the Google Maps API and push theM to the database. (KEYWORD: {新竹}/{東區/北區/香山區}/{所有里}的{咖啡廳})



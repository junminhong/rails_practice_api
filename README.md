### Raw Data
[User Json](https://github.com/kdan-mobile-software-ltd/phantom_mask/blob/master/data/users.json)

[Pharmacies Json](https://github.com/kdan-mobile-software-ltd/phantom_mask/blob/master/data/pharmacies.json)

### TODO
- [x] List all pharmacies that are open at a certain datetime
- [x] List all pharmacies that are open on a day of the week, at a certain time
- [x] List all masks that are sold by a given pharmacy, sorted by mask name or mask price
- [x] List all pharmacies that have more or less than x mask products within a price range
- [ ] Search for pharmacies or masks by name, ranked by relevance to search term
- [ ] The top x users by total transaction amount of masks within a date range
- [ ] The total amount of masks and dollar value of transactions that happened within a date range
- [ ] Edit pharmacy name, mask name, and mask price
- [ ] Remove a mask product from a pharmacy given by mask name
- [ ] Process a user purchases a mask from a pharmacy, and handle all relevant data changes in an atomic transaction


### 需求

- List all pharmacies that are open at a certain date time
  - 說明：列出特定日期時間開放的所有藥局
  - 控制器：PharmacyStoresController
  - model：PharmacyStore
  - route：pharmacy_stores
  - API：pharmacy_stores?datetime=xx:xx

    ```json
    [
    	{
    		pharmacy_store_id: xxx,
    		pharmacy_store_name: xxx,
    		pharmacy_store_open_time: xx:xx,
    		pharmacy_store_close_time: xx:xx
    	}
    ]
    ```

- List all pharmacies that are open on a day of the week, at a certain time
  - 說明：列出一週中的某一天營業的所有藥局
  - API：pharmacy_stores?week=1...7

    ```json
    [
    	{
    		pharmacy_store_id: xxx
    		pharmacy_store_name: xxx
    	}
    ]
    ```

- List all masks that are sold by a given pharmacy, sorted by mask name or mask price
  - 說明：列出指定藥局出售的所有口罩，按照口罩名稱或者口罩價格排序
  - API：pharmacy_masks?pharmacy_store_id=x&choose=0(name) or 1(price)&sort=ASC(由小至大) or DESC(由大至小)

    ```json
    [
    	{
    		mask_id: xxx
    		mask_name: xxx
    		mask_price: xxx
    	}
    ]
    ```

- List all pharmacies that have more or less than x mask products within a price range
  - 說明：列出口罩價格範圍內大於x或者小於x的所有藥局
  - API：pharmacy_stores?money=x&choose=0(big)1(small)

    ```json
    [
    	{
    		pharmacy_store_id: xxx
    		pharmacy_store_name: xxx
    	}
    ]
    ```

- Search for pharmacies or masks by name, ranked by relevance to search term
  - 說明：按照名稱搜尋藥房或口罩，並與搜尋詞的相關性排名
  - API：search?name= xxx

    ```json
    [
    	{
    		pharmacy_store_id: xxx
    		pharmacy_store_name: xxx
    	},
    	{
    		mask_id: xxx,
    		mask_name: xxx
    	}
    ]
    ```

- The top x users by total transaction amount of masks within a date range
  - 說明：在某個日期範圍內，按照口罩交易總數的前x位用戶
  - API：users?date=xxx

    ```json
    [
    	{
    		user_id: xxx,
    		user_name: xxx
    	}
    ]
    ```

- The total amount of masks and dollar value of transactions that happened within a date range
  - 說明：在某個日期範圍內，口罩總數以及價錢
  - API：pharmacy_masks?date=xxxx

    ```json
    [
    	{
    		mask_total_count: xxx,
    		mask_total_price: xxx
    	}
    ]
    ```

- Edit pharmacy name, mask name, and mask price
  - 說明：編輯藥局名稱，口罩名稱，口罩價格
  - API：pharmacy_stores?pharmacy_store_id=xx&mask_name=xx&mask_price=xx

    ```json
    [
    	{
    		msg: 'successful' or 'failed'
    	}
    ]
    ```

- Remove a mask product from a pharmacy given by mask name
  - 說明：從口罩名稱指定的藥局移除一個口罩產品
  - API：

    ```json
    [
    	{
    		msg: 'successful' or 'failed'
    	}
    ]
    ```

- Process a user purchases a mask from a pharmacy, and handle all relevant data changes in an atomic transaction
  - 說明：
  - API：

    ```json
    [
    	{
    		msg: 'successful' or 'failed'
    	}
    ]
    ```
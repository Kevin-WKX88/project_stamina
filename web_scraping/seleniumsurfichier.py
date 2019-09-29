import time, csv
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains

url = "https://www.strava.com/login"
driver = webdriver.Chrome()
driver.maximize_window()
email = "marguerite.ac@outlook.com"
password = "Ukulele91"
res = [['time', 'distance', 'elevation', 'pace', 'heartrate', 'cadence']]
timev = ''
distance = ''
elev = ''
pace = ''
heartrate = ''
cadence = ''

runs = open("201906urruty.txt","r")
a = runs.readlines()
runs.close()
print(len(a)*2,"minutes estimées")

if __name__ == "__main__":
    driver.get(url)
    action = ActionChains(driver)
    driver.find_element_by_id("email").send_keys(email)
    driver.find_element_by_id("password").send_keys(password)
    driver.find_element_by_id("login-button").click()
    time.sleep(1)
    
    for i in range (len(a)):
        run = a[i][:-1]
        res = [['time', 'distance', 'elevation', 'pace', 'heartrate', 'cadence']]
        
        driver.get(run)
        time.sleep(1)
        try:
            driver.find_element_by_xpath("//td[@data-type='heartrate']/div[@class='toggle-button']").click()
            driver.find_element_by_xpath("//td[@data-type='cadence']/div[@class='toggle-button']").click()
        except:
            continue
        grid = driver.find_element_by_id("grid")
        action.move_to_element(grid).perform()
        action.move_by_offset(-398, 0).perform()
        
        for i in range(266):
            action.move_by_offset(3, 0).perform()
            timev = driver.find_element_by_xpath("//*[@id='crossBar']/*[@class='crossbar-text']").text
            distance = driver.find_element_by_xpath("//*[@id='infobox-text-distance']/*[@class='value']").text
            elev = driver.find_element_by_xpath("//*[@id='infobox-text-altitude']/*[@class='value']").text
            pace = driver.find_element_by_xpath("//*[@id='infobox-text-pace']/*[@class='value']").text
            heartrate = driver.find_element_by_xpath("//*[@id='infobox-text-heartrate']/*[@class='value']").text
            cadence = driver.find_element_by_xpath("//*[@id='infobox-text-cadence']/*[@class='value']").text
            res.append([timev, distance, elev, pace, heartrate, cadence])
            action = ActionChains(driver)
        time.sleep(1)
        
        with open('Urutty_2019_06'+run[-10:]+'.csv', 'w') as csvFile:
            writer = csv.writer(csvFile)
            writer.writerows(res)
        csvFile.close()
    driver.close()   

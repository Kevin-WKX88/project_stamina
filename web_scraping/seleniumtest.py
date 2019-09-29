import time, csv
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains

url = "https://www.strava.com/login"
from webdriver_manager.chrome import ChromeDriverManager
driver = webdriver.Chrome(ChromeDriverManager().install())

driver.maximize_window()
email = "clement9155@hotmail.fr"
password = "Ukulele91"
res = [['time', 'distance', 'elevation', 'pace', 'heartrate', 'cadence']]
timev = ''
distance = ''
elev = ''
pace = ''
heartrate = ''
cadence = ''

if __name__ == "__main__":
    driver.get(url)
    action = ActionChains(driver)
    driver.find_element_by_id("email").send_keys(email)
    driver.find_element_by_id("password").send_keys(password)
    driver.find_element_by_id("login-button").click()
    time.sleep(1)
    driver.get("https://www.strava.com/activities/2533262240")
    time.sleep(1)
    driver.find_element_by_xpath("//td[@data-type='heartrate']/div[@class='toggle-button']").click()
    driver.find_element_by_xpath("//td[@data-type='cadence']/div[@class='toggle-button']").click()
    grid = driver.find_element_by_id("grid")
    for i in range(266):
        action.move_to_element(grid).perform()
        action.move_by_offset(-398 + 3*i, 0).perform()
        timev = driver.find_element_by_xpath("//*[@id='crossBar']/*[@class='crossbar-text']").text
        distance = driver.find_element_by_xpath("//*[@id='infobox-text-distance']/*[@class='value']").text
        elev = driver.find_element_by_xpath("//*[@id='infobox-text-altitude']/*[@class='value']").text
        pace = driver.find_element_by_xpath("//*[@id='infobox-text-pace']/*[@class='value']").text
        heartrate = driver.find_element_by_xpath("//*[@id='infobox-text-heartrate']/*[@class='value']").text
        cadence = driver.find_element_by_xpath("//*[@id='infobox-text-cadence']/*[@class='value']").text
        res.append([timev, distance, elev, pace, heartrate, cadence])
        action = ActionChains(driver)
    time.sleep(1)
    driver.close()
    with open('test3.csv', 'w') as csvFile:
        writer = csv.writer(csvFile)
        writer.writerows(res)
    csvFile.close()

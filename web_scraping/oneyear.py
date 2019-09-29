import time, re, csv, os
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains




def connect(driver):
    driver.get("https://www.strava.com/login")
    driver.find_element_by_id("email").send_keys("clement9155@hotmail.fr")
    driver.find_element_by_id("password").send_keys("Ukulele91")
    driver.find_element_by_id("login-button").click()


def getdata(user, rundate, driver):
    userUrl = "https://www.strava.com/athletes/" + user + "#interval?interval=" + rundate + "&interval_type=month&chart_type=miles&year_offset=0"
    driver.get(userUrl)


def getrun(url, driver):
    res = [['time', 'distance', 'elevation', 'pace', 'heartrate', 'cadence']]
    action = ActionChains(driver)
    driver.get(url)
    time.sleep(1)
    try:
        driver.find_element_by_xpath("//td[@data-type='heartrate']/div[@class='toggle-button']").click()
    except:
        return []
    try:
        enough = webDriver.find_element_by_xpath("//ul[@class='inline-stats section']/li/strong")
    except:
        return []


    if (float(re.search('^(.+?)<abbr', enough.get_attribute('innerHTML')).group(1).replace(',','.')) < 5):
        return[]
    try:
        driver.find_element_by_xpath("//td[@data-type='cadence']/div[@class='toggle-button']").click()
    except:
        return[]
    grid = driver.find_element_by_id("grid")
    action.move_to_element(grid).perform()
    action.move_by_offset(-398, 0).perform()

    for i in range(266):
        action.move_by_offset(3, 0).perform()
        timev = driver.find_element_by_xpath("//*[@id='crossBar']/*[@class='crossbar-text']").text
        distance = driver.find_element_by_xpath("//*[@id='infobox-text-distance']/*[@class='value']").text
        try:
            elev = driver.find_element_by_xpath("//*[@id='infobox-text-altitude']/*[@class='value']").text
        except:
            elev = 0
        pace = driver.find_element_by_xpath("//*[@id='infobox-text-pace']/*[@class='value']").text
        heartrate = driver.find_element_by_xpath("//*[@id='infobox-text-heartrate']/*[@class='value']").text
        try:
            cadence = driver.find_element_by_xpath("//*[@id='infobox-text-cadence']/*[@class='value']").text
        except:
            cadence = 0
        res.append([timev, distance, elev, pace, heartrate, cadence])
        action = ActionChains(driver)
    time.sleep(1)
    return res


def saverun(rundata, user, run):
    if not os.path.isdir('./data'):
        os.mkdir('./data')
    if not os.path.isdir('./data/' + user):
        os.mkdir('./data/' + user)
    if not os.path.isfile('./data/' + user + '/' + run):
        script_dir = os.path.dirname(__file__)  # Script directory
        full_path = os.path.join(script_dir, './data/' + user + '/' + run + '.csv')
        with open(full_path, 'w') as csvFile:
            writer = csv.writer(csvFile)
            writer.writerows(rundata)
        csvFile.close()

if __name__ == "__main__":
    userId = str(input("Enter user id :"))
    year = str(input("Enter year :"))
    months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    webDriver = webdriver.Chrome()
    webDriver.maximize_window()
    connect(webDriver)
    for month in months:
        date = year + month
        time.sleep(1)
        getdata(userId, date, webDriver)
        time.sleep(2)
        runList=[]
        for div in webDriver.find_elements_by_class_name("activity-title"):
            try:
                div.find_element_by_class_name("icon-run")
            except:
                continue
            print(div.find_element_by_class_name("icon-run").get_attribute('innerHTML'))
            text = div.get_attribute('innerHTML')
            found = re.search('href="(.+?)"', text).group(1)
            runList.append(found)
        for run in runList:
            runUrl = "https://www.strava.com" + run
            runId = re.search('activities/(.+?)$', run).group(1)
            if os.path.isfile('./data/' + userId + '/' + runId + '.csv'):
                continue
            data = getrun(runUrl,webDriver)
            if not data:
                continue
            saverun(data, userId, runId)
    webDriver.close()

# coding: utf-8

require "selenium-webdriver"
require "headless"
require "nokogiri"

$progress_bar = 0;

def getPhoneNumber()
  print("[!] Enter phone number [!]\n\n==> ");
  phoneNumber = gets().to_s;
  return (phoneNumber);
end

def fbProfileGet(phoneNumber)
  Headless.ly do
    res = "";
    driver = Selenium::WebDriver.for :firefox;
    wait = Selenium::WebDriver::Wait.new(:timeout => 10);
    driver.navigate.to "http://www.facebook.com/login/identify";
    element = driver.find_element(id: "identify_email");
    element.send_keys phoneNumber;
    element.submit;
    sleep(3);
    html = driver.page_source;
    driver.quit;
    page = Nokogiri::HTML(html);
    page.css(".mvm").each do |profile|
       res += profile.inner_html;
    end
    $progress_bar = 1;
    return (res);
  end
end

def loadingBar()
  print("\nPlease wait while searching...\n");
  while ($progress_bar == 0)
    sleep(1);
    print("|");
  end
end

def main()
  phoneNumber = getPhoneNumber();
  loadingTh = Thread.new { loadingBar() };
  profile = fbProfileGet(phoneNumber);
  loadingTh.join;
  print("\n\n");
  puts(profile);
end

main();

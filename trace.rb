# coding: utf-8

require "selenium-webdriver"
require "headless"
require "nokogiri"
require "catpix"

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

def getNamePic(profile, cond)
     if (cond == 0)
       img = profile.split("src=")[1].split(" alt=")[0];
       img[0] = '';
       img[img.length - 1] = '';
       return (img);
     else
       name = profile.split("fcb")[1].split("</")[0];
       name[0] = '';
       name[0] = '';
       return (name);
     end
end

def dispImg(imgUrl)
  Catpix::print_image URRRRRRRRRRRL,
                      :limit_x => 1.0,
                      :limit_y => 0,
                      :center_x => true,
                      :center_y => true,
                      :bg => "white",
                      :bg_fill => true;
end

def main()
  phoneNumber = getPhoneNumber();
  loadingTh = Thread.new { loadingBar() };
  profile = fbProfileGet(phoneNumber);
  loadingTh.join;
  print("\n\n");
  imgUrl = getNamePic(profile ,0);
  name = getNamePic(profile, 1);
  puts(imgUrl, name);
end

main();

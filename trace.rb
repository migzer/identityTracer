#!/usr/bin/ruby
# coding: utf-8

require "selenium-webdriver"
require "headless"
require "nokogiri"
require "catpix"
require "open-uri"

$progress_bar = 0;

def getPhoneNumber()
  phoneNumber = "ntm"
  while (checkIsDigits(phoneNumber) == false)
    print("[!] Enter phone number [!]\n\n==> ");
    phoneNumber = gets().to_s;
  end
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

def dispImg()
  Catpix::print_image "img",
                      :limit_x => 1.0,
                      :limit_y => 0,
                      :bg_fill => true;
end

def createImg(imgUrl)
  open(imgUrl) { |img|
    File.open("img", "wb") do |file|
      file.puts img.read
    end
  }
end

def checkFileExist()
  if (File.file?("img") == true)
    `rm img`
  end
end

def checkIsDigits(str)
  i = 0;
  while (i < str.length - 1)
    if (str[i] < '0' || str[i] > '9')
      return (false);
    end
    i += 1;
  end
  return (true);
end

def main()
  checkFileExist();
  phoneNumber = getPhoneNumber();
  loadingTh = Thread.new { loadingBar() };
  profile = fbProfileGet(phoneNumber);
  loadingTh.join;
  print("\n\n");
  imgUrl = getNamePic(profile ,0);
  name = getNamePic(profile, 1);
  puts(name);
  createImg(imgUrl);
  dispImg();
end

main();

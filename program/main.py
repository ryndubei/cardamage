from tkinter import *
from tkinter import filedialog
import shutil 
import os
from PIL import ImageTk,Image
import requests
import subprocess

root = Tk()

root.title("Car service estimator")


main_frame = Frame(root)


#dimensions of the window 
window_width  = 750
window_height = 700

#getting the dimensions of the screen 
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()

#finding the center point 
center_x = int(screen_width/2 - window_width)
center_y = int(screen_height/2 - window_height)

#putting it in the center 
root.geometry(f'{window_width}x{window_height}+{center_x}+{center_y}')

#window is resizable 
root.resizable(0,0)


#fwelcome page 
page_1 = Frame(main_frame)
page_1_lb = Label(page_1, text='Welcome to remote Car service estimator', font=('Bold', 20),background = "yellow", borderwidth=3, relief="groove")
page_1_lb.pack()

#adding image to page 1
img = Image.open("welcome_image.jpeg")
img = img.resize((400,400), Image.ANTIALIAS)
photo = ImageTk.PhotoImage(img)

label = Label(page_1, image  = photo)
label.pack(padx = 40)
page_1.pack(pady = 100)

#page to add inputs
page_2 = Frame(main_frame)
page_2_l1 = Label(page_2, text='Analysis phase', font=('Bold', 20),background = "cyan", borderwidth = 7, relief  = "ridge")
page_2_l3 = Label(page_2, text='Please input the pictures that you want to check', font=('Bold', 20), borderwidth = 3, relief = "sunken")

def get_photos():
    filepaths = filedialog.askopenfilenames()
    
    if not os.path.exists('./images/'):
        os.mkdir('./images/')
    #for filepath in filepaths:
        #args.append(filepath)
        #shutil.copy(filepath, './images/')
page_2_l2 = Button(page_2, text="Input pictures", width=10, command=get_photos)
page_2_l1.pack(padx = 100, pady = 25)


#adding image to page 2
img2 = Image.open("page 2.jpeg")
img2 = img2.resize((300,200), Image.ANTIALIAS)
photo2 = ImageTk.PhotoImage(img2)

pic_photo2 = Label(page_2, image = photo2)
pic_photo2.pack()

page_2_l3.pack()
page_2_l2.pack()


#haskell implementation 
dirname = os.path.dirname(__file__) 
bin_path = os.path.join(dirname, "bin", "car-exe")

print(args)


output = subprocess.check_output([bin_path] + args)

trying = output.decode("utf-8")
try1 = "hello"

#page to get ouput from haskell
page_3 = Frame(main_frame)
page_3_l1 = Label(page_3, text='Output', font=('Bold', 20))
page_3_l2 = Label(page_3, text = trying, font = ("Bold",15 ) )
page_3_l1.pack()
page_3_l2.pack()





#misc
page_4 = Frame(main_frame)
page_4_lb = Label(page_4, text='About', font=('Bold', 20))
page_4_lb.pack()


main_frame.pack(fill=BOTH, expand=True)

#pages variable of all the UI
pages = [page_1, page_2, page_3, page_4]
count = 0

def move_next_page():
    global count

    if not count > len(pages)-2:
        for p in pages:
            p.pack_forget()

    count += 1
    # counts how many pages
    if count < 4:
        page = pages[count]
        page.pack(pady=100)

def move_back_page():
        global count

        if not count == 0:

            for p in pages:
                p.pack_forget()

        count -= 1
        # counts how many pages
        if count > -1:
            page = pages[count]
            page.pack(pady=100)



bottom_frame = Frame(root)
# creating the back button 
back_btn = Button(bottom_frame, text='Back',
                     font=('Bold', 12),
                     bg='#1877f2', fg='blue', width=8,
                     command=move_back_page)
back_btn.pack(side=LEFT, padx=10)

# creating the next button 
next_btn = Button(bottom_frame, text='Next',
                     font=('Bold', 12),
                     bg='#1877f2', fg='blue', width=8,
                     command=move_next_page)
next_btn.pack(side=RIGHT, padx=10)

bottom_frame.pack(side=BOTTOM, pady=10)

     

root.mainloop()




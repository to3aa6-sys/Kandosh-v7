#include "Includes.h"
#import "LoadView/DTTJailbreakDetection.h"
#import "imgui/Il2cpp.h"
#import "Utils/Macros.h"
#import "Utils/hack/Function.h"
#import "Utils/Mem.h"
#include "font.h"
#include "hook/hook.h"
#import "Other/Vector/Vector3.h"
#import "Other/Vector/Vector2.h"
#import "Other/Vector/Quaternion.h"
#import "Other/Vector/Monostring.h"
#include "Other/Icon.h"
#include "Other/iconcpp.h"
ImFont *_espFont;
#import "Esp.h"
#include "Other/AimKill.cpp"

#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]

using namespace IL2Cpp;

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

UIView *view;
NSString *jail;
NSString *namedv;
NSString *deviceType;
NSString *bundle;
NSString *ver;
UILabel *menuTitle;

@implementation ImGuiDrawView

bool Guest;
bool Telecar, Telekill;

bool ResetGuest(void *instance){
    if (Guest) return true; 
    Guest = false;
    return false;
}

void hooking() {
    void* address[] = {
        (void*)getRealOffset(ENCRYPTOFFSET("0x61995C0")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x44C752C")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x49844F4")), 
        (void*)getRealOffset(ENCRYPTOFFSET("0x61BCB44")), 
    };
    
    void* function[] = {
        (void*)_LateUpdate,
        (void*)ResetGuest,
        (void*)DamageInfoHook,
        (void*)_Update
    };
    
    hook(address, function, 4);

    get_transform = (void *(*)(void *))getRealOffset(ENCRYPTOFFSET("0x4A3BAB4")); 
    get_position = (Vector3 (*)(void*)) getRealOffset(ENCRYPTOFFSET("0x4AA1D88"));
    get_camera = (void *(*)()) getRealOffset(ENCRYPTOFFSET("0x4C116B8"));
    worldToScreen = (Vector3 (*)(void *, Vector3)) getRealOffset(ENCRYPTOFFSET("0x4EFCE34"));
    WorldToViewpoint = (Vector3 (*)(void *, Vector3, int ))getRealOffset(ENCRYPTOFFSET("0x4EFCD20"));
}

- (void)drawInMTKView:(MTKView*)view {
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    if (MenDeal == true) {
        [self.view setUserInteractionEnabled:YES];
    } else {
        [self.view setUserInteractionEnabled:NO];
    }

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();

        if (MenDeal == true) {
            char* Gnam = (char*) [[NSString stringWithFormat:nssoxorany("KANDOSH V7 PANEL")] cStringUsingEncoding:NSUTF8StringEncoding];
            ImGui::Begin(Gnam, &MenDeal, ImGuiWindowFlags_AlwaysAutoResize);
            
            if (ImGui::BeginTabBar(oxorany("Bar"))) {
                if (ImGui::BeginTabItem(oxorany(ICON_FA_CROSSHAIRS " Aim"))) {
                    ImGui::Checkbox(oxorany("Enable Aimbot"), &aimStart);
                    ImGui::SliderFloat(oxorany("Aim Fov"), &AimFov, 0.0f, 360.0f);
                    ImGui::EndTabItem();
                }
                if (ImGui::BeginTabItem(oxorany(ICON_FA_EYE " Esp"))) {
                    ImGui::Checkbox(oxorany("Enable Esp"), &ESPEnable);
                    ImGui::Checkbox(oxorany("Esp Lines"), &ESPLine);
                    ImGui::EndTabItem();
                }
                if (ImGui::BeginTabItem(oxorany(ICON_FA_ADDRESS_CARD " Info"))) {
                    ImGui::Text(oxorany("Developer: KANDOSH"));
                    ImGui::TextLinkOpenURL(oxorany("Telegram"), oxorany("https://t.me/iii5_k"));
                    ImGui::EndTabItem();
                }
                ImGui::EndTabBar();
            }
            ImGui::End();
        }

        DrawEsp();
        ImGui::Render();
        ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), commandBuffer, renderEncoder);
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    
    menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    menuTitle.text = [NSString stringWithUTF8String:oxorany("KANDOSH V7")];
    menuTitle.textColor = UIColorFromHex(0x72FF13);
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    menuTitle.center = CGPointMake(CGRectGetMidX(mainWindow.bounds), 20);
    [mainWindow addSubview: menuTitle];

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGui_ImplMetal_Init(_device);
    return self;
}

- (void)updateIOWithTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);
    io.MouseDown[0] = (anyTouch.phase != UITouchPhaseEnded && anyTouch.phase != UITouchPhaseCancelled);
}

void *hack_thread(void *) {
    sleep(5);
    hooking();
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}

@end

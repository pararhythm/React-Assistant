import { InputBase } from '@mui/material';
import AttachFileIcon from '@mui/icons-material/AttachFile';
import {useState} from 'react';

export default function Input() {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);  

  return (
    <div className="bg-[#2D2C2C] w-4xl min-h-36 border-2 rounded-2xl border-[#3b3b3b] flex flex-col justify-between p-4">
      <InputBase
        multiline={true}
        className="w-full"
        placeholder="Explain useEffect like I'm 5 years old"
        slotProps={{
          input: {
            sx: {
              fontSize: 16,
              color: '#FFFFFF',
              '&::placeholder': {
                color: '#9CA3AF',
                opacity: 0.5,
              },
            },
          },
        }}
      />
      <div className="flex flex-row justify-between">
        <button className="border-2 rounded-2xl bg-transparent border-white/15 flex items-center justify-center w-8 h-8" onClick={(e) => setAnchorEl(e.currentTarget)}>
          <AttachFileIcon sx={{color: "#FFFFFF", opacity: 20, fontSize: "1rem", transform: 'rotate(45deg)'}}  />
        </button>
        <div className="right-toolbar"></div>
      </div>
    </div>
  );
}

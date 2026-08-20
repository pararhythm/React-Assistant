import { InputBase } from '@mui/material';

export default function Input() {
  return (
    <div className="bg-[#2D2C2C] w-4xl min-h-36 border-2 rounded-2xl border-[#3b3b3b] flex flex-col justify-between p-4">
      <InputBase
        multiline
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
      <div className="input-toolbar">
        <div className="left-toolbar"></div>
        <div className="right-toolbar"></div>
      </div>
    </div>
  );
}
